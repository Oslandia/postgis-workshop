#!/bin/bash

# Create all Schemas
psql -d postgis -c "DROP SCHEMA if exists admin CASCADE;"
psql -d postgis -c "DROP SCHEMA if exists hydro CASCADE;"
psql -d postgis -c "DROP SCHEMA if exists rff CASCADE;"
psql -d postgis -c "CREATE SCHEMA admin"
psql -d postgis -c "CREATE SCHEMA hydro"
psql -d postgis -c "CREATE SCHEMA rff"

# Import Shapefile
shp2pgsql -s 2154 -d -I -D -W LATIN1 data/GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_LAMB93_FR-ED161/COMMUNE/COMMUNE.shp admin.commune | psql -d postgis
shp2pgsql -s 2154 -d -I -D -W LATIN1 data/COURS_D_EAU/*.shp hydro.cours_eau | psql -d postgis
shp2pgsql -s 2154 -d -I -D -W LATIN1 data/REGION_HYDROGRAPHIQUE/*.shp hydro.region | psql -d postgis


# CSV data load
psql postgis -c "DROP TABLE IF EXISTS rff.station";
psql postgis -c "CREATE TABLE rff.station (code_ligne integer, nom varchar, nature varchar, latitude_wgs84 double precision, longitude_wgs84 double precision, wgs84 varchar, dept integer, cp integer, ville varchar);"
psql postgis -c "COPY rff.station FROM '$(pwd)/data/gares_ile_de_france.csv' DELIMITER ';' CSV HEADER;"


# Cleanup
psql postgis -c "VACUUM ANALYZE"


# EXPLANATIONS
#  - SQL SCHEMA
#  - Not store data in public schema
#  - Always set an SRID
#  - Always create a spatial index
#  - Shp2pgsql: Shapefile encoding
