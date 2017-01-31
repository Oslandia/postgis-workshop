#/bin/bash

dropdb --if-exists postgis
createdb postgis
psql -d postgis -c "create extension postgis"
