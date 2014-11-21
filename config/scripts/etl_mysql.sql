
-- ETL database
-- Tables required by GEM to monitor ETL runs

CREATE TABLE etl_log(
	  run_id 					INT 			NOT NULL 	PRIMARY KEY 	AUTO_INCREMENT
	, start_date 				DATETIME
	, end_date 					DATETIME
	, pdi_version 				VARCHAR(20)
	, status 					ENUM( 'aborted', 'running', 'failed', 'success', 'deleted', 'unknown')
);

CREATE TABLE task_log(
	  batch_id 					INT 			NOT NULL 	PRIMARY KEY 	AUTO_INCREMENT
	, run_id 					INT 			NOT NULL
	, task_name 				VARCHAR(100)	NOT NULL
	, config_file 				VARCHAR(255)
	, start_date 				DATETIME
	, end_date 					DATETIME
	, stage 					ENUM( 'not started', 'pre-processing', 'extract', 'transform', 'load', 'post-processing', 'finished')
	, status 					ENUM( 'running', 'failed', 'success', 'deleted', 'unknown')
	, records_read 				INT
	, records_written 			INT
);

