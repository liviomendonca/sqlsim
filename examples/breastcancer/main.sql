/*
This script adds data for the breastcancer example.
It creates the necessary tables, insert data and make an example query
*/
CREATE TABLE IF NOT EXISTS breastcancer (
    -- store breastcancer observation data
    id int PRIMARY KEY,
    date_stamp DATE,
    hospital geometry(point),
    clump_thickness int,
    cell_size_uniformity int,
    cell_shape_uniformity int,
    marginal_adhesion int,
    single_epithelial_cell_size int,
    bare_nuclei int,
    bland_chromatin int,
    normal_nucleoli int,
    mitoses int,
    "class" bpchar(10)
);

CREATE TABLE IF NOT EXISTS hospitals (
    -- store hospitals locations
    id int PRIMARY KEY,
    loc geometry(point)
);

INSERT INTO hospitais (id, loc)
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

