-- Get the container up and running before try to run this file

/*
This file has examples of a possible queries with the similarity search
*/

-- remeber to truncate tables CENTROIDS and CENT_ASSIGN to recalculate clusters
TRUNCATE centroids, cent_assign;

-- two dimension
SELECT 
	spatial_sim(hospital, 3.5) AS spatial,
	metric_sim(id, radius1, texture1, perimeter1, 3) AS metric,
	count(id)
FROM breastcancer 
GROUP BY
	CUBE(spatial, metric)
ORDER BY spatial, metric ASC;


-- three dimension
SELECT 
	spatial_sim(hospital, 5) AS spatial,
	extract(month from time_stamp) as temporal,
	metric_sim(id, radius1, texture1, perimeter1, 5) AS metric,
	count(id)
FROM breastcancer 
GROUP BY
	CUBE(spatial, temporal, metric)
ORDER BY spatial, temporal, metric ASC;
