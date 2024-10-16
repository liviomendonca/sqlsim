-- main functions

-- Spatial dimension

CREATE TABLE IF NOT EXISTS regions (
    -- stores the centoids of the spatial clusters
	id integer PRIMARY KEY,
    topology geometry(polygon)
);


CREATE FUNCTION spatial_sim(geometry(point), d FLOAT)
/*
The GROUP BY function `spatial_sim` receives a geometry point and a float threshold
and returns an integer representing the group id of the entry point
*/
RETURNS integer AS
$$
DECLARE
    circle geometry;
    lines integer;
    r RECORD;
    tplg geometry; -- topology
BEGIN
    SELECT count(*) INTO lines FROM regions;

    circle = ST_Buffer($1, d);

    IF lines = 0 THEN
        INSERT INTO regions
        VALUES (1, circle);
        
        RETURN 1;
    END IF;

    -- verify if the point belongs to any existing group
    FOR r IN SELECT * FROM regions LOOP
        IF ST_Contains(r.topology, $1) THEN
            tplg = ST_Intersection(r.topology, circle);

            UPDATE regions
            SET topology = tplg
            WHERE id = r.id;

            RETURN r.id;
        END IF;
    END LOOP;

    INSERT INTO regions
    VALUES ((lines + 1), circle);

    RETURN (lines + 1);
END;
$$ LANGUAGE PLPGSQL;




-- Metric dimension

CREATE TABLE IF NOT EXISTS centroids (
    -- stores the centroids: id and its center
    id integer primary key,
    center geometry(pointZ)
);


CREATE TABLE IF NOT EXISTS cent_assign (
    -- `cent_assign` stores the relation match between `centroids` and the data
    obs_id integer PRIMARY KEY, -- observation id
    centroid integer -- centroid id
);


CREATE FUNCTION metric_sim(pid integer, double precision, double precision, double precision, d FLOAT)
/*
For the GROUP BY function `metric_sim` we have:
INPUT:
    `pid`, an point id which is the id in the data table
    three params as the features we're analysing from the data
    `d` a threshold
OUTPUT:
    a group id
*/
RETURNS integer AS
$$
DECLARE
	gid integer; -- group id
    p geometry;
BEGIN
    -- create a geom(point) from feature
    p = ST_MakePoint($2, $3, $4);

    -- check if `centroids` is empty
    IF (SELECT count(*) FROM centroids) = 0 THEN
        INSERT INTO centroids
            VALUES (1, p);
        gid = 1;
    ELSE
        -- if `centroids` isn't empty, we got two possibilities:
            -- 1. verify if the point had been parsed already
            -- 2. calculate the distance between each centroid and the point

        -- option 1:
        SELECT centroid INTO gid FROM cent_assign WHERE obs_id = pid;
        IF gid IS NOT NULL THEN
            RETURN gid;
        END IF;

        -- option 2:
        gid = aggr_metric_sim(p, d);
    END IF;

    INSERT INTO cent_assign VALUES (pid, gid);

	RETURN gid;
END;
$$ LANGUAGE PLPGSQL;


CREATE FUNCTION aggr_metric_sim(geometry(pointZ), d FLOAT)
/*
This function, aggregate metric similarity (aggr_metric_sim), is responsible for determine
centroid the point is related to. It receives the point to be parsed and the similarity threshold.
*/
RETURNS integer AS
$$
DECLARE
    i integer;
    g centroids%rowtype;
BEGIN
	SELECT count(*) FROM centroids INTO i;
    FOR g IN SELECT * FROM centroids LOOP
        IF ST_3DDWithin(g.center, $1, d) THEN
            UPDATE centroids SET center = ST_MakePoint(
                (ST_X(g.center) + ST_X($1)) / 2,
                (ST_Y(g.center) + ST_Y($1)) / 2,
                (ST_Z(g.center) + ST_Z($1)) / 2
            ) WHERE id = g.id;

            RETURN g.id;
        END IF;
	END LOOP;
	
	INSERT INTO centroids VALUES (i+1, $1);
	RETURN i+1;
END;
$$ LANGUAGE plpgsql;
