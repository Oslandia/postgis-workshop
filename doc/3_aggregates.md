3 - Aggregates
==============

Union
-----

Aggregate all city administrative area in region administrative area

```SQL
SELECT code_reg,
       ST_Union(geom) AS geom
FROM admin.commune
GROUP BY code_reg;
```

We now add a generated unique integer to allow QGIS DBManager to load the data :

```SQL
SELECT (row_number() OVER ())::integer AS gid, 
       code_reg,
       ST_Union(geom) AS geom
FROM admin.commune
GROUP BY code_reg;
```


EXPLANATIONS: 
- http://www.postgis.net/docs/manual-2.0/ST_Union.html
- row_number() and SQL WINDOWING

Collect
-------

Same than previously, but now we use _ST_Collect_ instead of _ST_Union_

```SQL
SELECT (row_number() OVER ())::integer AS gid, 
       ST_CollectionExtract(ST_Collect(geom), 3) AS geom
FROM admin.commune
GROUP BY code_reg;
```

EXPLANATIONS: 
What is an MULTI*, what is a COLLECTION
- Why ST_Collect is faster than ST_Union
- http://www.postgis.net/docs/manual-2.0/ST_CollectionExtract.html

More collections
----------------

Like previously, but now we use _ST_CollectionHomogenize_ instead of _ST_CollectionExtract_

```SQL
SELECT (row_number() OVER ())::integer AS gid, 
       ST_CollectionHomogenize(ST_Collect(geom)) AS geom
FROM admin.commune
GROUP BY code_reg;
```

EXPLANATIONS: 
- http://www.postgis.net/docs/manual-2.0/ST_CollectionHomogenize.html

Merge lines
-----------

Retrieve a single river (Rhone) and aggregate all LINESTRING subparts in a single geometry

_ST_LineMerge_ interest :

```SQL
SELECT
   ST_Summary(ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2))) AS geom,
   ST_Summary(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
FROM hydro.cours_eau 
WHERE code_hydro = 'V---0000';  -- Hydrological code from Rhone river
```

Using _ST_LineMerge_ and view it through QGIS DBManager:

```SQL
SELECT 1::integer AS gid,
      ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom
FROM hydro.cours_eau 
WHERE code_hydro = 'V---0000';  -- Hydrological code from Rhone river
```
