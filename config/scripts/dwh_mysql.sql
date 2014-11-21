
-- DWH database
-- Tables required to run the sample tasks

CREATE TABLE dim_date(
	  date_id 					INT 			NOT NULL 	PRIMARY KEY
	, year 						INT
	, quarter					INT
	, month_number 				INT
	, month_name_full 			VARCHAR(10)
	, month_name_short			VARCHAR(3)
	, day_of_month				INT
	, day_of_year				INT
	, iso_year_of_week			INT
	, iso_week_of_year			INT
	, day_of_week 				INT
	, day_of_week_full 			VARCHAR(10)
	, day_of_week_short 		VARCHAR(3)
	, date_string 				VARCHAR(10)
	, date_value				DATE
	) engine=myisam;
	CREATE INDEX idx_dim_date_yqm ON dim_date( date_id, year, quarter, month_number, month_name_full );
	CREATE INDEX idx_dim_date_yqmd ON dim_date( date_id, year, quarter, month_number, month_name_full, day_of_month, date_string );
	CREATE INDEX idx_dim_date_yw ON dim_date( date_id, iso_year_of_week );
	CREATE INDEX idx_dim_date_ywd ON dim_date( date_id, iso_year_of_week, day_of_week, day_of_week_full, date_string );
	CREATE INDEX idx_dim_date_lookup ON dim_date( date_id, date_string );


	CREATE TABLE dim_time(
	  time_id 					INT 			NOT NULL 	PRIMARY KEY
	, hours24 					INT
	, hours24_lpad 				VARCHAR(2)
	, hours12 					INT
	, hours12_lpad 				VARCHAR(2)
	, am_pm_indicator			VARCHAR(2)
	, minutes 					INT
	, minutes_lpad 				VARCHAR(2)
	, seconds 					INT
	, seconds_lpad 				VARCHAR(2)
	, time_formatted12_hm 		VARCHAR(7)
	, time_formatted24_hm 		VARCHAR(5)
	, time_formatted12_hms 		VARCHAR(11)
	, time_formatted24_hms 		VARCHAR(9)
	) engine=myisam;
	CREATE INDEX idx_dim_time_hm12 ON dim_time( time_id, hours12, minutes, time_formatted12_hm, am_pm_indicator );
	CREATE INDEX idx_dim_time_hm12lpad ON dim_time( time_id, hours12_lpad, minutes_lpad, time_formatted12_hm, am_pm_indicator );
	CREATE INDEX idx_dim_time_hms12 ON dim_time( time_id, hours12, minutes, seconds, time_formatted12_hms, am_pm_indicator );
	CREATE INDEX idx_dim_time_hms12lpad ON dim_time( time_id, hours12_lpad, minutes_lpad, time_formatted12_hms, am_pm_indicator );
	CREATE INDEX idx_dim_time_hm24 ON dim_time( time_id, hours24, minutes, time_formatted24_hm );
	CREATE INDEX idx_dim_time_hm24lpad ON dim_time( time_id, hours24_lpad, minutes_lpad, time_formatted24_hm );
	CREATE INDEX idx_dim_time_hms24 ON dim_time( time_id, hours24, minutes, seconds, time_formatted24_hms );
	CREATE INDEX idx_dim_time_hms24lpad ON dim_time( time_id, hours24_lpad, minutes_lpad, time_formatted24_hms );
	CREATE INDEX idx_dim_time_lookup ON dim_time( time_id, time_formatted24_hms );