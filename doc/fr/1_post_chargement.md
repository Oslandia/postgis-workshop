1 - Post-chargement
===================

PostGIS vérification
--------------------

```SQL

-- Vérifions que l'extension postgis est correctement chargée
-- pour la base courante

SELECT postgis_full_version();
```

Vérifions les metadonnées
-------------------------

```SQL
-- Vérifions que les metadonnées sont correctement paramétrées

SELECT * FROM geometry_columns;
```


A propos de la requête :

- Avec PostGIS 2.0 geometry_columns est désormais une vue, par conséquent il n'y a aucun risque de séparer les géométries des metadonnées.


Vérifions les données
---------------------

Vérifions si le jeu de données contient des géométrie invalides

```SQL

SELECT gid, ST_IsValidReason(geom) 
FROM hydro.region 
WHERE NOT ST_IsValid(geom);

SELECT gid, ST_IsValidReason(geom) 
FROM admin.commune 
WHERE NOT ST_IsValid(geom);
```


NOTE : les données de type POINT sont toujours valides, la vérification est surtout faite pour les données surfaciques.


A propos de la requête :

- Qu'est-ce qu'une géométrie invalide ?
- SpécificationsOGC SFS

Vérifions les index
--------------------

Vérifions si les index spatiaux ont été correctement créés

Avec PGAdmin ou psql (commande \di)



A propos des index :

- Qu'est-ce qu'un index spatial ?
- A quoi sert-il ?
