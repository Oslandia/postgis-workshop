2 - Analyses basiques
=====================

Trouvons les villes populaires
------------------------------

```SQL

-- Récupérons les 100 villes les plus denses

SELECT * 
FROM admin.commune 
ORDER BY population / ST_Area(geom) DESC
LIMIT 100;
```


Exercice : 

- Affichez le résultat dans QGIS à l'aide du DBManager (ou créez une table temporaire)

Voisines de Toulouse
--------------------

Récupérons toutes les villes situées autours de celle nommée Toulouse

```SQL

SELECT c.gid, c.geom, c.nom_com
FROM admin.commune AS c
WHERE ST_Touches( c.geom, 
                  (SELECT geom FROM admin.commune WHERE nom_com = 'TOULOUSE')
                )
;
```
Exercice : 

- Affichez le résultat dans QGIS à l'aide du DBManager

Rivières les plus longues
-------------------------

Quelles rivières sont les plus longues ?

 
```SQL

SELECT SUM(ST_Length(geom)), toponyme
FROM hydro.cours_eau
WHERE toponyme IS NOT NULL
GROUP BY toponyme
ORDER BY SUM(ST_Length(geom)) DESC
LIMIT 10;
```

NOTE: 

- le premier résultat est du au fait que les données sont incomplètes

A propos de la requête :

- NULL / NOT NULL
- GROUP BY et les fonction d'aggrégation (telle que SUM)
- ORDER BY ASC / DESC
- LIMIT

Buffers
-------

```SQL

SELECT ST_Buffer(geom, 10000) AS geom, gid from admin.commune where nom_com = 'TOULOUSE';

```

Faisons des buffers (zones tampons) autours des villes, puis autours des villes frontalières de Toulouse.


Distances
---------

-- Quelles sont les distances entre Toulouse et les autres grandes villes ?

```SQL

SELECT nom_com,
       population AS population,
       ST_Distance(geom, (SELECT geom FROM admin.commune WHERE nom_com = 'TOULOUSE')) / 1000 AS dist_km
FROM admin.commune
WHERE population > 150000
AND NOT nom_com = 'TOULOUSE';

```

A propos de la requête :

- Sous-requêtes SQL
- ST_Distance
