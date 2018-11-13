PostGIS workshop
================

Ressources
----------

Quelques liens utiles :

* Site PostGIS: http://www.postgis.net
* Documentation PostGIS : http://www.postgis.net/docs/manual-2.0/
* Documentation PostgreSQL : http://www.postgresql.org/docs/9.2/interactive/index.html
* Ce workshop sur Github : https://github.com/Oslandia/postgis-workshop
* Validation GeoJSON : http://geojsonlint.com/
* GeoJSON sur GitHub : https://help.github.com/articles/mapping-geojson-files-on-github

Pour démarrer
-------------

Commencez par télécharger la dernière version de ce workshop :

https://github.com/Oslandia/postgis-workshop/archive/master.zip

Sauvegardez le zip dans votre répertoire home et décompressez le dans un répertoire _workshop_.

```bash
$ cd ~
$ wget -O postgis-workshop-master.zip 'https://codeload.github.com/vpicavet/postgis-workshop/zip/master'
$ mkdir workshop
$ unzip -o postgis-workshop-master.zip -d workshop
$ cd workshop/postgis-workshop-master
```

La première étape est de créer la base de données et de charger les données

Lancez les 3 scripts contenus dans le répertoire _scripts_ pour créer la base, télécharger le jeu de test, et charger les données dans la base.

Pour charger les shapefiles, vous pouvez aussi utiliser l'utilitaire _shp2pgsql-gui_.

Vous pouvez relancer les scripts si une erreur se produit pendant l'exécution.


```bash
$ cd scripts
$ sudo -u postgres bash STEP_1-CREATE.sh
$ bash STEP_2-DOWNLOAD-DATA.sh
$ sudo -u postgres bash STEP_3-LOAD.sh
```

A présent, vous pouvez utiliser PGAdmin3 (ou 4) pour parcourir vos données et QGIS pour les visualiser.

Essayez d'appliquer une belle symbologie pour les couches de données dans QGIS, et vous pourrez passer à l'étape suivante.
