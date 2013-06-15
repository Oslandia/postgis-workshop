#/bin/sh
dropdb postgis
createdb postgis
psql postgis < /usr/share/postgresql/9.1/contrib/postgis-2.0/postgis.sql
psql postgis < /usr/share/postgresql/9.1/contrib/postgis-2.0/spatial_ref_sys.sql


# Explanations:
#  - New alternate syntax using EXTENSION
