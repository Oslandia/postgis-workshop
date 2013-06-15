1 - Post-loading
================

Check PostGIS
-------------

```SQL

-- Check that postgis extension is correctly loaded
-- for the current database

SELECT postgis_full_version();
```

Check metadata
--------------

```SQL
-- Check that metadata informations are correctly set

SELECT * FROM geometry_columns;
```


About the query :
- With PostGIS 2.0 geometry_columns is now a view so no risk to decorrelate geometry data stored and metadata (from geometry_columns).


Check data
----------

Check if any invalid geometry in a dataset

```SQL

SELECT gid, ST_IsValidReason(geom) 
FROM hydro.region 
WHERE NOT ST_IsValid(geom);

SELECT gid, ST_IsValidReason(geom) 
FROM admin.commune 
WHERE NOT ST_IsValid(geom);
```


NOTE : POINT data are always valid, we focus here on surfacic data  (far most invalid cases)


About the query : 
- What is invalid data ?
- OGC SFS specifications

Check indexes
-------------

Check if Spatial Indexes were correctly created

With PgAdmin or with psql and \di command

About indexes : 
- What is spatial index ?
- What does it stand for ?
