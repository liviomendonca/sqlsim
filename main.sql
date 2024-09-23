/*
The GROUP BY function `spatial_sim` receives a geometry point and a float threshold
and returns an integer representing the group id of the entry point

`regioes` in the code below is the table in which the clusters are saved.
Change it as necessary.
`topologia` is an attribute of `regioes`.
*/
CREATE FUNCTION spatial_sim(geometry(point), d FLOAT)
RETURNS INT AS
$$
DECLARE
    circle geometry;
    lines int;
    r RECORD;
    tplg geometry; -- topology
BEGIN
    SELECT count(*) INTO lines FROM regioes;

    circle = ST_Buffer($1, d);

    IF lines = 0 THEN
        INSERT INTO regioes
        VALUES (1, circle);
        
        RETURN 1;
    END IF;

    -- verify if the point belongs to any existing group
    FOR r IN SELECT * FROM regioes LOOP
        IF ST_Contains(r.topologia, $1) THEN
            tplg = ST_Intersection(r.topologia, circle);

            UPDATE regioes
            SET topologia = tplg
            WHERE id = r.id;

            RETURN r.id;
        END IF;
    END LOOP;

    INSERT INTO regioes
    VALUES ((lines + 1), circle);

    RETURN (lines + 1);
END;
$$ LANGUAGE PLPGSQL;


/*
We need two support tables.
`centroids` stores the centroids: id and it's shape
`cent_assign` stores the relation match between `centroids` and the data
*/
CREATE TABLE IF NOT EXISTS centroids (
    id INT primary key,
    centroid geometry(pointZ)
);

CREATE TABLE IF NOT EXISTS cent_assign (
    obs_id int PRIMARY KEY, -- observation id
    centroid int -- centroid id
);


/*
For the GROUP BY function `metric_sim` we have:
INPUT:
    `pid`, an point id which is the id in the data table
    three params as the features we're analysing from the data
    `d` a threshold
OUTPUT:
    a group id
*/
CREATE FUNCTION metric_sim(pid INT, INT, INT, INT, d FLOAT)
RETURNS INT AS
$$
DECLARE
	gid INT; -- group id
    point geometry;
BEGIN
    -- create a geom(point) from feature
    point = ST_MakePoint($2, $3, $4);

    -- check if `centroids` is empty
    IF (SELECT count(*) FROM centroids) = 0 THEN
        INSERT INTO centroids
            VALUES (1, ponto);
        gid = 1;
    ELSE
        -- if `centroids` isn't empty, we got two possibilities:
            -- 1. verify if the point had been parsed already
            -- 2. calculate the distance between each centroid and the point

        -- option 1:
        SELECT centroid INTO gid FROM cent_assign WHERE bc_id = pid;
        IF gid IS NOT NULL THEN
            RETURN gid;
        END IF;

        -- option 2:
        gid = aggr_metric_sim(point, d);
    END IF;

    INSERT INTO cent_assign VALUES (pid, gid);

	RETURN gid;
END;
$$ LANGUAGE PLPGSQL;


/*
The function below, aggregate metric similarity (aggr_metric_sim), is responsible for determine
centroid the point is related to. It receives the point to be parsed and the similarity threshold.
*/
CREATE FUNCTION aggr_metric_sim(geometry(pointZ), d FLOAT)
RETURNS int AS
$$
DECLARE
    i int;
    g centroids%rowtype;
BEGIN
	SELECT count(*) FROM centroids INTO i;
    FOR g IN SELECT * FROM centroids LOOP
        IF ST_3DDWithin(g.centro, $1, d) THEN
            UPDATE centroids SET centro = ST_MakePoint(
                (ST_X(g.centro) + ST_X($1)) / 2,
                (ST_Y(g.centro) + ST_Y($1)) / 2,
                (ST_Z(g.centro) + ST_Z($1)) / 2
            ) WHERE id = g.id;

            RETURN g.id;
        END IF;
	END LOOP;
	
	INSERT INTO centroids VALUES (i+1, $1);
	RETURN i+1;
END;
$$ LANGUAGE plpgsql;


-- Now we can run queries like:
SELECT 
	spatial_sim(hosp, 3.5) AS espaco,
	metric_sim(id, ct, czu, csu, 3) AS metrico,
	count(id)
FROM bc2 b 
GROUP BY
	CUBE(espaco, metrico)
ORDER BY espaco, metrico ASC;

