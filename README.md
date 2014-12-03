# GEM - Generic ETL Machine


## Motivation

GEM is a framework that aims to allow faster development cycles by implementing most of the common features in a semi-automated fashion (logging, monitoring, data lineage, etc.)

It’s goal is to limit the amount of configurations available in PDI and allow faster development cycles for ETL.


## Key Concepts

**Process**: A process is an independent part of an ETL, defined by a single source (a specific database, a type of file, a web service) and a common destination (a staging database, a data warehouse, etc)

**Task**: Each process has one or more tasks, which consist of atomic data extraction, transformation and loading. A task is defined by a single target table (regardless of how many source tables or files it reads from. Tasks are logged in the task_log table of the ETL database.

**Run**: a run is a single execution of the ETL, iterating over all processes and tasks. Each ETL run is logged in the etl_log table in the ETL database.

**Environment**: an environment is simply a name that identifies a machine running GEM. Usual names are dev, uat or prod, but other names may be used freely, e.g., nelson-laptop or miguel-sandbox. Each environment will use different configuration. The ETL environment is defined via the `ETL_ENVIRONMENT` variable in `kettle.properties`.

**Config file**: by default, the global GEM configuration is located in `config/config.${ETL_ENVIRONMENT}.xml`. However, a different configuration file may be used by defining the `ETL_CONFIG_FILE` variable in `kettle.properties`(e.g., to keep sandbox config files from being committed to git.

One of the main features of GEM is the ability to prevent multiple instances from running at the same time. This is called the Watchdog. when GEM starts it will look at the status of every logged run and abort if it finds an ETL run marked as “running” (see Logging and monitoring below). When GEM finishes the status of the run is marked as either Success or Failed, depending on the exit status. However, if GEM fails unexpectedly, the status may not be correctly updated, causing future runs to abort until manual intervention fixes the issue.

## Installation

* Clone gem into your target machine;
* Run the `config/scripts/etl_mysql.sql` script in your desired ETL database (change the script if you want to use a database other than MySQL or MariaDB;
* Set the `ETL_ENVIRONMENT` variable in your `kettle.properties` (e.g., dev)
* Change the `config/config.dev.xml` file according to your needs:
* Define folder locations;
* Configure email sending
* Set up the ETL database connection 
* Create your ETL process folders inside the config folder and create the `database.${ETL_ENVIRONMENT}.properties` config file inside each process folder;
* Create the configuration files for each ETL task (an XML file) inside the process folders;
* Create the target tables and run.

To use the provided samples:
* Create the stage and dwh databases in a MySQL server (if you want to use a different database you will need to make some configuration changes)
* Run the scripts/stage_mysql.sql and scripts/dwh_mysql.sql scripts in the corresponding databases;
Create a dwh database inside a MonetDB installation of your choosing (if you want to use a different database change configuration files accordingly).
* Run the scripts/dwh_monetdb.sql script inside MonetDB;
* Load the Adventure Works scripts into a MySQL database ( http://awmysql.sourceforge.net/ )
* Change the paths inside the global config file to point to the appropriate locations
* Change the database properties files inside each process (located in the config folder) to point to the appropriate locations. Defaults: MySQL runs in localhost:3306; monetDB runs in localhost:50000. Username and password for MySQL is root/password, for MonetDB it’s monetdb/monetdb.
* Run the ETL.

If you want to disable a process (e.g, the Dim initialisation process, just move it to the disabled_tasks folder)


## Global configuration

The configuration file is by default located in `config/config.${ETL_ENVIRONMENT}.xml`. You can change the location of this file by defining the variable `ETL_CONFIG_FILE` in your `kettle.properties` file.

The configuration of GEM is made of the following items:

* `locations/root`: the GEM base folder
* `locations/log`: the destination of all GEM log files
* `locations/tmp`: where all temporary files (created at the end of the Extract and Transform phases) will be located
* `locations/tasks`: the folder where GEM processes and tasks will be located
* `locations/transformations`: where task specific ktr and kjb files will be placed
* `locations/inbox`: a prefix to add to the file path of any input file (see below)

* `email/smtp`: the SMTP server to use to send emails; you may choose to use an Authenticated SMTP server (supports only SSL for the time being), or not
* `email/sender`: the name and email address to be used as sender of all emails
* `email/destination`: To, Cc and Bcc email addresses (you may use a comma separated list of emails or a mailing list)
`email/success`: whether to send an email if the ETL succeeds, its subject and message body
* `email/warning`: whether to send an email when a non-blocking task fails, its subject and message body
* `email/error`: whether to send an email on a fatal ETL error, its subject and message body

* `database`: the database connection to use to log each ETL run (currently supported: MySQL and PostgreSQL)

About the locations/inbox configuration: In a common scenario, when the ETL is meant to parse files, the file path is fixed. For example, `/mnt/serverlogs/my_webapp`; When developing such an ETL it’s usually necessary to mimic that folder structure in a development laptop. However, putting all files in a single place may be a disadvantage, especially when processing ETLs for multiple projects. It’s preferable to have those files in a project-specific folder, e.g., `/home/user/projects/myproject/inbox`. The `locations/inbox` folder allows us to define a path prefix to file locations. In this example, we would copy a sample of files into `/home/user/projects/myproject/inbox/mnt/serverlogs/my_webapp`and GEM would be able to find them in DEV, using a path relative to the inbox path, and in PROD, using an absolute path (no inbox path defined).
	

## Defining database connections

Each project accepts only one source and one target database connections. That is the very definition of a process (e.g, read from systemA into a staging area).

Each database connection is defined by its type, host, port, database name, username and password.

We may have different database connections defined for different environments, by creating multiple `database.${ETL_ENVIRONMENT}.properties` files.

## Creating your own processes and tasks

The `config/disabled_tasks/000_template.xml` file includes all the XML tags currently supported by GEM and the role they play in the overall ETL process.

The structure of a task XML is as follows:

* `task/name`: a human readable name for the task

* `task/blocker`: whether the whole ETL should stop if the task returns an error, or ignore the error and continue. When a non-blocking task returns an error a warning email is sent (if so defined in the config file). Defaults to true

* `task/preProcessing`: a set of tasks to execute before the Extract phase. These tasks may be of three types: a sourceQuery (SQL statement to run on the source database), a targetQuery (SQL statement to run on the target database) and a job. Can be used to drop indexes before running the ETL, truncate target tables, or download a set of files

* `task/parameter`: for incremental Extract processes, defines the parameter name to use, how to query its value and which default value to use.
task/parameter/name: the parameter name to use. May be used as a variable, for example in the source/extract/query. Will be used to filter filenames if Extract type is defined as File (only filenames greater than the parameter value will be read)

* `task/parameter/query`: the query to run on the Target database to determine the value to use (e.g., the max filename present in the target or the max timestamp already extracted); must return a single row
task/parameter/default: the default value to use if the parameter query returns no results

* `task/source`: the definition of the Extract process
task/source/type: currently the following types are supported: DB (read from the source database defined in the database.properties file), File (extract from a file or set of files), Custom (e.g. to read from a web service) or null (empty extract phase)

* `task/source/query`: for Extracts of the DB type, the SQL query to run on the source system. It may (should?) include a filter based on a parameter value

* `task/source/path`: base path of files to read, if type is set to File

* `task/source/pattern`: filename pattern, if type is set to File

* `task/transformation`: for File or Custom extract types, a specific transformation for the task at hand (e.g., a CSV file input specifying the field names expected, or a HTTP client to query a web service).

* `task/transform`: the task specific logic for the Transform part of the ETL. It includes only 1 sub-tag, the transformation, with the ktr filename to use (from the `locations/transformations` folder)

* `target`: The definitions of the Load stage

* `target/loader`: the specific bulk loader to use. Currently supported are MySQL, MonetDB and InfiniDB

* `target/table/name`: the name where the data should land

* `postProcessing`: similar to preProcessing, but takes place at the end of the Load phase. Useful to archive source files, or re-build indices in the target tables, delete extracted data from the source database, build aggregation tables, etc


## Sample tasks


The current GEM installation includes a set of samples you may use. They include three different types of processes:
* a DB based ETL, from Microsoft’s Adventure Works sample database;
* a file based ETL using data from the World bank;
a web-service ETL reading exchange rates from the European Central Bank.

For more information on the details of each sample, read their configuration files and the installation notes above.

## Data lineage

The data's origin may be traced back to the original data source by using the row_number and batch_id columns. Each extract task assigns a unique batch_id number and adds a row number field to each row of data. In case the data sources are files, the filename is also added to the data stream. By using the combination batch_id/row_number/filename you will be able to retrace the processing steps to, if needed, the original source of data.

See the sample files provided for examples on how to use the batch_id and row_number fields to trace data back from MonetDB to the stagin area and from there to the original source.

Each batch_id is linked to a specific task run, logged in the task_log table, which provides information regarding the start and end dates, exit status and number of records read/written. 

## Logging and monitoring

Each ETL run and each task are logged in the ETL database, under etl_log and task_log. For etl_log, the following information is logged:
* a unique integer ID
* start timestamp
* finish timestamp
* PDI version
* status (Aborted, Success, Failure, Running, ...)

Each task will include the following:
* a unique integer ID
* the run Id that launched it
* the start and end timestamps
* the name of the task and the configuration filename used
* the number of records read from source
* the number of records written to the target
* the stage its currently at (Not started, Pre-processing, Extract, Transform, Load, Post-processing or Finished)
* the task result (Success, Failure, Running, …)

The number of records read is done immediately after the Extract process finishes and before starting the Transformation part.

The number of records written is read from the Target table, after the Load phase completes (therefore, the actual number of records that landed on the target table, not the number of records PDI tried to load). Bear in mind that some bulk loaders reject invalid records silently, whereas others return an error after a certain number of errors.


## Future development

GEM is not by any means a complete product. It does make the ETL development process faster, but there’s a lot to be done. The following is a non-exhaustive list of planned future features:
* Support for Create, Drop and Truncate table statements (avoiding running separate SQL scripts);
* Support more source databases (Oracle, MSSQL, PostgreSQL, ...)
* Support more target databases (Vertica, Greenplum, ...)
* Add a user interface to read the ETL results and log files
* Add support for Hadoop based sources and/or targets
* Add support for running GEM inside a PDI cluster, with a dynamic set of Carte slave servers
* Add support for different schedules for different processes (as of now, all processes run everytime GEM is launched)

Some of these are likely to be implemented soon (for example, support for Oracle inputs and Vertica outputs), so stay tuned.

