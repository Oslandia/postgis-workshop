PostGIS workshop
================

The first step is to initialize the database and load the data.

Launch the two scripts in the _script_ directory to create the database and load the data.

Adapt the scripts if your data is located at another location.

To load the shapefiles, you can also use the _shp2pgsql-gui_ GUI tool.

```bash
$ cd scripts
$ sh STEP_1-CREATE.sh
$ sh STEP_2-LOAD.sh
```

Now you can use pgAdmin3 to look at your data, and load it with QGIS.
Try to do some nice symbology for the data in QGIS and proceed to next step.
