/*
This script prepares data for the breastcancer example.
It creates the necessary tables and insert data
*/


-- activate postgis extension
CREATE EXTENSION postgis;


CREATE TABLE IF NOT EXISTS breastcancer (
    -- store breastcancer observation data
    id integer PRIMARY KEY,
    diagnosis char(1),
    radius1 double precision,
    texture1 double precision,
    perimeter1 double precision,
    area1 double precision,
    smoothness1 double precision,
    compactness1 double precision,
    concavity1 double precision,
    concave_points1 double precision,
    symmetry1 double precision,
    fractal_dimension1 double precision,
    radius2 double precision,
    texture2 double precision,
    perimeter2 double precision,
    area2 double precision,
    smoothness2 double precision,
    compactness2 double precision,
    concavity2 double precision,
    concave_points2 double precision,
    symmetry2 double precision,
    fractal_dimension2 double precision,
    radius3 double precision,
    texture3 double precision,
    perimeter3 double precision,
    area3 double precision,
    smoothness3 double precision,
    compactness3 double precision,
    concavity3 double precision,
    concave_points3 double precision,
    symmetry3 double precision,
    fractal_dimension3 double precision
);


COPY breastcancer FROM '/breastcancer/wdbc.data' DELIMITER ',';


CREATE TABLE IF NOT EXISTS hospitals (
    -- store hospitals locations
    id int PRIMARY KEY,
    loc geometry(point)
);


INSERT INTO hospitals (id, loc)
VALUES
    (1, ST_MakePoint(10.4, 18.1)),
    (2, ST_MakePoint(12.5, 18.4)),
    (3, ST_MakePoint(5.6, 14.9)),
    (4, ST_MakePoint(5.1, 12.9)),
    (5, ST_MakePoint(7.1, 13.4)),
    (6, ST_MakePoint(11.8, 10.8)),
    (7, ST_MakePoint(16.9, 7.0)),
    (8, ST_MakePoint(16.3, 5.4)),
    (9, ST_MakePoint(18.6, 4.7)),
    (10, ST_MakePoint(19.7, 9.4)),
    (11, ST_MakePoint(21.1, 8.9)),
    (12, ST_MakePoint(25.5, 11.4)),
    (13, ST_MakePoint(26.4, 12.4)),
    (14, ST_MakePoint(27.1, 11.6)),
    (15, ST_MakePoint(35.9, 10.5)),
    (16, ST_MakePoint(37.8, 9.5)),
    (17, ST_MakePoint(37.0, 9.0)),
    (18, ST_MakePoint(36.5, 7.3)),
    (19, ST_MakePoint(30.7, 9.1));


CREATE OR REPLACE FUNCTION date_generator()
RETURNS DATE AS
$$
DECLARE
    start_date DATE := '2024-01-01';
    end_date DATE := '2024-06-30';
    random_days INTEGER;
BEGIN
    random_days := floor(random() * (end_date - start_date + 1));
    RETURN start_date + random_days;
END;
$$ LANGUAGE PLPGSQL;


ALTER TABLE breastcancer
ADD COLUMN time_stamp date,
ADD COLUMN hospital geometry(point);


CREATE OR REPLACE FUNCTION draw_time_place()
-- add a date and a hospital for each entry of `breastcancer`
RETURNS void AS
$$
DECLARE
    i int = 0;
    h geometry(point);
    d date;
    r breastcancer%rowtype;
BEGIN
    FOR r IN SELECT id FROM breastcancer LOOP
        i = i + 1;
        d = date_generator(); -- draw a date

        -- draw a hospital
        SELECT loc INTO h
            FROM hospitals
            WHERE id = (SELECT FLOOR(random() * 19) + 1);

    	UPDATE breastcancer
        SET time_stamp = d,
            hospital = h
        WHERE breastcancer.id = r.id;
    END LOOP;
    RETURN;
END;
$$ language plpgsql;


SELECT draw_time_place();
