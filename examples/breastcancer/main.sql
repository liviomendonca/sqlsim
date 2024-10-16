-- Get the container up and running before try to run this file

/*
This file has an example of a possible query with the similarity search
*/


SELECT 
	spatial_sim(hospital, 3.5) AS space,
	metric_sim(id, radius1, texture1, perimeter1, 3) AS metric,
	count(id)
FROM breastcancer 
GROUP BY
	CUBE(space, metric)
ORDER BY space, metric ASC;
