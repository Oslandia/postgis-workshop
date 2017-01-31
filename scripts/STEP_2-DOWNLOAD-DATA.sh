#!/bin/bash

#
# Requirements:
#
# - 7z – Debian package is p7zip-full
# - wget
# - unzip
#

error() {
    local errmsg=$1
    echo "Error: ${errmsg}"
    exit 1
}

type 7z > /dev/null 2>&1 || error "7z is not available"
type wget > /dev/null 2>&1 || error "wget is not available"
type unzip > /dev/null 2>&1 || error "unzip is not available"

mkdir -p data
cd data

# GEOFLA commune
if [[ ! -f GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28.7z ]]
then
    wget -O GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28.7z 'https://wxs-telechargement.ign.fr/oikr5jryiph0iwhw36053ptm/telechargement/inspire/GEOFLA_THEME-COMMUNE_2016$GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28/file/GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28.7z'
fi

if [[ ! -d GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28 ]]
then
    7z x GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28.7z
fi

# BDCarthage COURS_D_EAU
if [[ ! -f COURS_D_EAU_FXX-shp.zip ]]
then
    wget -O COURS_D_EAU_FXX-shp.zip 'http://services.sandre.eaufrance.fr/telechargement/geo/ETH/BDCarthage/FXX/2014/arcgis/FranceEntiere/COURS_D_EAU_FXX-shp.zip'
fi

if [[ ! -d COURS_D_EAU ]]
then
    unzip -d COURS_D_EAU COURS_D_EAU_FXX-shp.zip
fi

# BDCarthage REGION_HYDROGRAPHIQUE
if [[ ! -f REGION_HYDROGRAPHIQUE_FXX-shp.zip ]]
then
    wget -O REGION_HYDROGRAPHIQUE_FXX-shp.zip 'http://services.sandre.eaufrance.fr/telechargement/geo/ETH/BDCarthage/FXX/2014/arcgis/FranceEntiere/REGION_HYDROGRAPHIQUE_FXX-shp.zip'
fi

if [[ ! -d REGION_HYDROGRAPHIQUE ]]
then
    unzip -d REGION_HYDROGRAPHIQUE REGION_HYDROGRAPHIQUE_FXX-shp.zip
fi

# Gares ferroviaires Ile de France
if [[ ! -f gares_ile_de_france.csv ]]
then
    wget -O gares_ile_de_france.csv 'http://data.iledefrance.fr/explore/dataset/gares_ferroviaires_de_tous_types_exploitees_ou_non/download?format=csv'
fi

cd ..
