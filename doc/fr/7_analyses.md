7 - Analyses
============

Intersection
------------

Récupérons toutes les communes traversées par une rivière, ordonnées de la première à la dernière :


```SQL
WITH river AS
(
  SELECT geom
  FROM hydro.cours_eau
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone
)

SELECT nom_com
FROM admin.commune AS c, river AS r
WHERE ST_Intersects(c.geom, r.geom)
ORDER BY ST_LineLocatePoint(
    ST_LineMerge(r.geom),
    ST_ClosestPoint(r.geom, c.geom))
;
```

Utilisons la reprojection à la volée et visualisons le résultat sous QGIS :

```SQL
SELECT  (row_number() OVER ())::integer AS gid,
        ST_Transform(ST_SetSRID(
            ST_MakePoint(longitude_wgs84, latitude_wgs84), 4326), 2154
        ) AS geom
FROM rff.station;
```


A propos de la requête :
- références spatiales
- http://www.postgis.net/docs/manual-2.0/ST_Transform.html

Généralisation
--------------

Généralisation de données : simplification de géométries :

```SQL
WITH river AS
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom
  FROM hydro.cours_eau
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone
)

SELECT 1::integer AS gid, ST_Simplify(geom, 250) AS geom
FROM river;
```

Exercice :
- Affichez la données dans QGIS
- Changez progressivement la tolérance de la fonction simplify

A propos de la requête :
- Generalisation
- Soucis topologiques
- http://www.postgis.net/docs/manual-2.0/ST_Simplify.html

Recherche par buffer
--------------------

Récupérons les communes situées à 50km du centre de Toulouse :


```SQL
SELECT gid, nom_com, geom
FROM admin.commune
WHERE ST_Intersects(geom,
 (SELECT ST_Buffer(ST_Centroid(geom), 50000)
  FROM admin.commune
  WHERE nom_com = 'TOULOUSE'
 ));
```

La même chose en utilisant une CTE, avec de bonnes performances :


```SQL
WITH toulouse_50km AS
(
  SELECT ST_Buffer(ST_Centroid(geom), 50000) AS geom
  FROM admin.commune
  WHERE nom_com = 'TOULOUSE'
)

SELECT gid, nom_com, c.geom
FROM admin.commune AS c, toulouse_50km AS t
WHERE ST_Intersects(c.geom, t.geom);
```

La même chose mais avec des performances dégradées à cause ST_buffer imbriquée dans ST_Intersects :


```SQL
WITH toulouse AS
(
  SELECT ST_Centroid(geom) AS geom
  FROM admin.commune
  WHERE nom_com = 'TOULOUSE'
)

SELECT gid, nom_com, c.geom
FROM admin.commune AS c, toulouse AS t
WHERE ST_Intersects(c.geom, ST_Buffer(t.geom, 50000));
```

Une dernière, avec la fonction _ST_Dwithin_ :

```SQL
select
    t1.*
from
    admin.commune as t1
join
    admin.commune as t2
on
    ST_DWithin(t1.geom, ST_Centroid(t2.geom), 50000)
where
    t2.nom_com = 'TOULOUSE';
```


A propos de la requête :

- Les index et les opérateurs spatiaux peuvent améliorer grandement les performances

Plus proches voisins
--------------------

Les grandes communes sont généralement situées le long des grands fleuves.
Trouvons pour chaque grande commune la plus proche rivière :


```SQL
SELECT c.nom_com,
       c.population * 1000 AS population,
       r.toponyme,
       ST_Distance(r.geom, c.geom) AS dist

FROM admin.commune AS c,
     hydro.cours_eau AS r

WHERE r.classe = '1' -- uniquement les grandes rivières
AND   r.toponyme IS NOT NULL
AND   (c.population * 1000) > 100000
AND   r.geom && ST_Expand(c.geom, 10000)
ORDER BY r.geom <-> c.geom;
```

A propos de la requête :

- Bbox et geometrie
- Opérateur d'intersection &&
- Opérateur KNN <#> et <->
