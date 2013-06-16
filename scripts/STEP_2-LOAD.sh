# Create all Schemas
psql postgis -c "DROP SCHEMA if exists admin;"
psql postgis -c "DROP SCHEMA if exists hydro;"
psql postgis -c "DROP SCHEMA if exists rff;"
psql postgis -c "CREATE SCHEMA admin"
psql postgis -c "CREATE SCHEMA hydro"
psql postgis -c "CREATE SCHEMA rff"

# Import Shapefile
shp2pgsql -s 2154 -d -I -D -W LATIN1 ../../data/geofla_commune_l93/*.SHP admin.commune | psql postgis 
shp2pgsql -s 2154 -d -I -D -W LATIN1 ../../data/carthage/COURS_D_EAU.SHP hydro.cours_eau | psql postgis
shp2pgsql -s 2154 -d -I -D -W LATIN1 ../../data/carthage/REGION_HYDROGRAPHIQUE.SHP hydro.region | psql postgis


# CSV data load
psql postgis -c "DROP TABLE IF EXISTS rff.station";
psql postgis -c "CREATE TABLE rff.station (name varchar, type varchar, region varchar, lat double precision, lon double precision);"
psql postgis -c "COPY rff.station FROM '/home/vagrant/workshop/data/rff/gare_2012.csv' DELIMITER ',' CSV;"


# Cleanup
psql postgis -c "VACUUM ANALYZE"


# EXPLANATIONS
#  - SQL SCHEMA 
#  - Not store data in public schema
#  - Always set an SRID
#  - Always create a spatial index
#  - Shp2pgsql: Shapefile encoding
