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
$ cd
$ sudo chown -R vagrant.vagrant /workshop
$ unzip -o postgis-workshop-master -d workshop
$ cd workshop/postgis-workshop-master
```

The first step is to initialize the database and load the data.

Launch the two scripts in the _script_ directory to create the database and load the data.

Adapt the scripts if your data is located at another location.

To load the shapefiles, you can also use the _shp2pgsql-gui_ GUI tool.

You can re-run those scripts if you screw up the database.
```bash
$ ln -s /workshop/data /home/vagrant/workshop
```

```bash
$ cd scripts
$ sh STEP_1-CREATE.sh
$ sh STEP_2-LOAD.sh
```

Now you can use pgAdmin3 to look at your data, and load it with QGIS.


Try to do some nice symbology for the data in QGIS and proceed to next step.
