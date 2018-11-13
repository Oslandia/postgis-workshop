3 - Agrégation
==============

Union
-----

Agrégeons les communes d'une même région :


```SQL
SELECT code_reg,
       ST_Union(geom) AS geom
FROM admin.commune
GROUP BY code_reg;
```

On ajoute un identifiant unique pour que QGIS puisse afficher la donnée :


```SQL
SELECT (row_number() OVER ())::integer AS gid, 
       code_reg,
       ST_Union(geom) AS geom
FROM admin.commune
GROUP BY code_reg;
```


A propos de la requête :
- http://www.postgis.net/docs/manual-2.0/ST_Union.html
- row_number() et SQL WINDOWING

Collect
-------

Idem que précédement, mais cette fois-ci en utilisant _ST_Collect_ à la place de _ST_Union_


```SQL
SELECT (row_number() OVER ())::integer AS gid, 
       ST_CollectionExtract(ST_Collect(geom), 3) AS geom
FROM admin.commune
GROUP BY code_reg;
```

A propos de la requête : 

- Qu'est-ce qu'un MULTI*, qu'est-ce qu'une COLLECTION
- Pourquoi ST_Collect is plus rapide que ST_Union
- http://www.postgis.net/docs/manual-2.0/ST_CollectionExtract.html

D'autres fonction de collecte
-----------------------------

Comme précédement, mais en utilisant _ST_CollectionHomogenize_ à la place de _ST_CollectionExtract_


```SQL
SELECT (row_number() OVER ())::integer AS gid, 
       ST_CollectionHomogenize(ST_Collect(geom)) AS geom
FROM admin.commune
GROUP BY code_reg;
```

A propos de la requête :

- http://www.postgis.net/docs/manual-2.0/ST_CollectionHomogenize.html

Fusion de lignes
----------------

Récupérons et agrégeons toutes les LINESTRING composant le fleuve Rhone en une seule géométrie


_ST_LineMerge_ :

```SQL
SELECT
   ST_Summary(ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2))) AS geom,
   ST_Summary(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
FROM hydro.cours_eau 
WHERE code_hydro = 'V---0000';
-- Code Hydrologique du Rhone
;
```

Pour visualiser sous QGIS:


```SQL
SELECT 1::integer AS gid,
      ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom
FROM hydro.cours_eau 
-- Hydrological code from Rhone river
WHERE code_hydro = 'V---0000';
;
```
