PostGIS workshop
================

Resources
---------

Some useful links :
* PostGIS Home : http://www.postgis.net
* PostGIS Documentation : http://www.postgis.net/docs/manual-2.0/
* PostgreSQL Documention : http://www.postgresql.org/docs/9.2/interactive/index.html
* This workshop on GitHub : https://github.com/vpicavet/postgis-workshop
* GeoJSON validation : http://geojsonlint.com/
* GeoJSON on GitHub : https://help.github.com/articles/mapping-geojson-files-on-github

Get started
-----------

First download the latest version of this workshop :

https://codeload.github.com/vpicavet/postgis-workshop/zip/master

Save to the home directory and unzip it to the _workshop_ directory.

```bash
$ cd ~
$ wget -O postgis-workshop-master.zip 'https://codeload.github.com/vpicavet/postgis-workshop/zip/master'
$ mkdir workshop
$ unzip -o postgis-workshop-master.zip -d workshop
$ cd workshop/postgis-workshop-master
```

The first step is to initialize the database and load the data.

Launch the three scripts in the _scripts_ directory to create the database, download data sets,  and load the data into the database.

To load the shapefiles, you can also use the _shp2pgsql-gui_ GUI tool.

You can re-run those scripts in case of any problem.

```bash
$ cd scripts
$ sudo -u postgres bash STEP_1-CREATE.sh
$ bash STEP_2-DOWNLOAD-DATA.sh
$ sudo -u postgres bash STEP_3-LOAD.sh
```

Now you can use pgAdmin3 to look at your data, and load it with QGIS.

Try to do some nice symbology for the data in QGIS and proceed to next step.
