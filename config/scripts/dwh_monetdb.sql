
-- DWH database
-- Tables required to run the sample tasks

CREATE TABLE dim_date(
  date_id 					BIGINT 			NOT NULL 	PRIMARY KEY
, year_number 				BIGINT
, quarter_number			BIGINT
, month_number 				BIGINT
, month_name_full 			VARCHAR(10)
, month_name_short			VARCHAR(3)
, day_of_month				BIGINT
, day_of_year				BIGINT
, iso_year_of_week			BIGINT
, iso_week_of_year			BIGINT
, day_of_week 				BIGINT
, day_of_week_full 			VARCHAR(10)
, day_of_week_short 		VARCHAR(3)
, date_string 				VARCHAR(10)
, date_value				TIMESTAMP
, batch_id 					BIGINT
);

CREATE TABLE dim_time(
  time_id 					BIGINT 			NOT NULL 	PRIMARY KEY
, hours24 					BIGINT
, hours24_lpad 				VARCHAR(2)
, hours12 					BIGINT
, hours12_lpad 				VARCHAR(2)
, am_pm_indicator			VARCHAR(2)
, minutes 					BIGINT
, minutes_lpad 				VARCHAR(2)
, seconds 					BIGINT
, seconds_lpad 				VARCHAR(2)
, time_formatted12_hm 		VARCHAR(7)
, time_formatted24_hm 		VARCHAR(5)
, time_formatted12_hms 		VARCHAR(11)
, time_formatted24_hms 		VARCHAR(9)
, batch_id 					BIGINT
);

CREATE TABLE dim_customer(
	  customer_id				BIGINT			NOT NULL 	PRIMARY KEY 	
	, version					BIGINT
	, date_from					TIMESTAMP
	, date_to					TIMESTAMP
	, source_customer_key		BIGINT
	, account_number			VARCHAR(30)		
	, customer_type				VARCHAR(3)	
	, territory					VARCHAR(150)	
	, country_region_code		VARCHAR(9)		
	, country_name				VARCHAR(150)	
	, stage_customer_row_number	BIGINT			
	, stage_customer_batch_id	BIGINT			
	, row_number				BIGINT
	, batch_id					BIGINT
);

CREATE TABLE dim_product(
	  product_id				BIGINT 		NOT NULL 	PRIMARY KEY 	
	, version					BIGINT
	, date_from					TIMESTAMP
	, date_to					TIMESTAMP
	, source_product_key		BIGINT
	, product_number 			VARCHAR(25)
	, product					VARCHAR(450)
	, category 					VARCHAR(150)
	, subcategory				VARCHAR(150)
	, modified_date				TIMESTAMP
	, stage_product_row_number	BIGINT
	, stage_product_batch_id	BIGINT
	, row_number				BIGINT
	, batch_id					BIGINT
);


CREATE TABLE dim_online_order(
	online_order_id				BIGINT			NOT NULL 	PRIMARY KEY 	
,	online_order_type 			VARCHAR(1)
, 	online_order_description 	VARCHAR(10)
);
INSERT INTO dim_online_order values( 1, null, null);
INSERT INTO dim_online_order values( 2, 'Y', 'Online');
INSERT INTO dim_online_order values( 3, 'N', 'In store');



CREATE TABLE dim_currency(
	  currency_id				BIGINT 		NOT NULL 	PRIMARY KEY 	
	, source_currency_key		BIGINT
	, currency_code				VARCHAR(9)
	, modified_date				TIMESTAMP
	, stage_currency_row_number	BIGINT
	, stage_currency_batch_id	BIGINT
	, row_number				BIGINT
	, batch_id					BIGINT
);

CREATE TABLE fact_orders
(	  order_date_id				 	BIGINT 		
	, due_date_id			 		BIGINT
	, ship_date_id 					BIGINT
	, online_order_id 		 		BIGINT
	, currency_id 					BIGINT
	, customer_id 		 			BIGINT
	, product_id 					BIGINT
	, status 						BIGINT
	, order_qty 					BIGINT
	, line_total			 		DOUBLE
	, sales_orderheader_row_number 	BIGINT
	, sales_orderheader_batch_id 	BIGINT
	, sales_ordetdetail_row_number 	BIGINT
	, sales_orderdetail_batch_id	BIGINT
	, row_number 					BIGINT
	, batch_id 						BIGINT
);



