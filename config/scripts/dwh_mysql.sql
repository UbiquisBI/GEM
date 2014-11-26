	
-- DWH database
-- Tables required to run the sample tasks

CREATE TABLE dim_date(
  date_id 							INTEGER 			NOT NULL 	PRIMARY KEY
, year 								INTEGER
, quarter							INTEGER
, month_number 						INTEGER
, month_name_full 					VARCHAR(10)
, month_name_short					VARCHAR(3)
, day_of_month						INTEGER
, day_of_year						INTEGER
, iso_year_of_week					INTEGER
, iso_week_of_year					INTEGER
, day_of_week 						INTEGER
, day_of_week_full 					VARCHAR(10)
, day_of_week_short 				VARCHAR(3)
, date_string 						VARCHAR(10)
, batch_id 							INTEGER
) engine=myisam;
CREATE INDEX idx_dim_date_yqm ON dim_date( date_id, year, quarter, month_number, month_name_full );
CREATE INDEX idx_dim_date_yqmd ON dim_date( date_id, year, quarter, month_number, month_name_full, day_of_month, date_string );
CREATE INDEX idx_dim_date_yw ON dim_date( date_id, iso_year_of_week );
CREATE INDEX idx_dim_date_ywd ON dim_date( date_id, iso_year_of_week, day_of_week, day_of_week_full, date_string );
CREATE INDEX idx_dim_date_lookup ON dim_date( date_id, date_string );


CREATE TABLE dim_time(	
  time_id 							INTEGER 			NOT NULL 	PRIMARY KEY
, hours24 							INTEGER
, hours24_lpad 						VARCHAR(2)
, hours12 							INTEGER
, hours12_lpad 						VARCHAR(2)
, am_pm_indicator					VARCHAR(2)
, minutes 							INTEGER
, minutes_lpad 						VARCHAR(2)
, seconds 							INTEGER
, seconds_lpad 						VARCHAR(2)
, time_formatted12_hm 				VARCHAR(7)
, time_formatted24_hm 				VARCHAR(5)
, time_formatted12_hms 				VARCHAR(11)
, time_formatted24_hms 				VARCHAR(9)
, batch_id 							INTEGER
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



CREATE TABLE dim_customer(
	  customer_id					INTEGER			NOT NULL 	PRIMARY KEY 	AUTO_INCREMENT
	, version						INTEGER
	, date_from						DATETIME
	, date_to						DATETIME
	, source_customer_key			INTEGER
	, account_number				VARCHAR(30)		
	, customer_type					VARCHAR(3)	
	, territory						VARCHAR(150)	
	, country_region_code			VARCHAR(9)		
	, country_name					VARCHAR(150)	
	, stage_customer_row_number		INTEGER			
	, stage_customer_batch_id		INTEGER			
	, row_number					INTEGER
	, batch_id						INTEGER
)engine=MyISAM;
CREATE INDEX idx_dim_customer_batch_id on dim_customer(batch_id);
CREATE INDEX idx_dim_customer_source_batch_id on dim_customer(stage_customer_batch_id);
CREATE INDEX idx_dim_customer_lookup on dim_customer(customer_id, source_customer_key);
CREATE INDEX idx_dim_customer_hierarchy on dim_customer(customer_id, country_name, territory, account_number);
CREATE INDEX idx_dim_customer_type on dim_customer( customer_id, customer_type, account_number);


CREATE TABLE dim_product(
	  product_id					INTEGER 		NOT NULL 	PRIMARY KEY 	AUTO_INCREMENT
	, version						INTEGER
	, date_from						DATETIME
	, date_to						DATETIME
	, source_product_key			INTEGER
	, product_number 				VARCHAR(25)
	, product						VARCHAR(450)
	, category 						VARCHAR(150)
	, subcategory					VARCHAR(150)
	, modified_date					DATETIME
	, stage_product_row_number		INTEGER
	, stage_product_batch_id		INTEGER
	, row_number					INTEGER
	, batch_id						INTEGER
)engine=MyISAM;	
CREATE INDEX idx_product_batch_id on dim_product(batch_id);
CREATE INDEX idx_product_source_batch_id on dim_product(stage_product_batch_id);
CREATE INDEX idx_product_lookup on dim_product(product_id, version, date_from, date_to, source_product_key);
CREATE INDEX idx_product_hierarchy on dim_product(product_id, category, subcategory, product);


CREATE TABLE dim_online_order(
	online_order_id					INTEGER			NOT NULL 	PRIMARY KEY 	AUTO_INCREMENT
,	online_order_type 				VARCHAR(1)
, 	online_order_description 		VARCHAR(10)
);
INSERT INTO dim_online_order values( 1, null, null);
INSERT INTO dim_online_order values( 2, 'Y', 'Online');
INSERT INTO dim_online_order values( 3, 'N', 'In store');



CREATE TABLE dim_currency(
	  currency_id					INTEGER 		NOT NULL 	PRIMARY KEY 	AUTO_INCREMENT
	, source_currency_key			INTEGER
	, currency_code					VARCHAR(9)
	, modified_date					DATETIME
	, stage_currency_row_number		INTEGER
	, stage_currency_batch_id		INTEGER
	, row_number					INTEGER
	, batch_id						INTEGER
)engine=MyISAM;
CREATE INDEX idx_currency_batch_id on dim_currency(batch_id);
CREATE INDEX idx_currency_source_batch_id on dim_currency(stage_currency_batch_id);
CREATE INDEX idx_currency_lookup on dim_currency(currency_id, source_currency_key);


CREATE TABLE fact_orders
(	  order_date_id				 	INTEGER 		
	, due_date_id			 		INTEGER
	, ship_date_id 					INTEGER
	, online_order_id 		 		INTEGER
	, currency_id 					INTEGER
	, customer_id 		 			INTEGER
	, product_id 					INTEGER
	, status 						INTEGER
	, order_qty 					INTEGER
	, line_total			 		DOUBLE
	, sales_orderheader_row_number 	INTEGER
	, sales_orderheader_batch_id 	INTEGER
	, sales_ordetdetail_row_number 	INTEGER
	, sales_orderdetail_batch_id	INTEGER
	, row_number 					INTEGER
	, batch_id 						INTEGER
)engine=MyISAM;
CREATE INDEX idx_sales_batch_id on fact_orders(batch_id);
CREATE INDEX idx_sales_source_batch_id on fact_orders(sales_orderheader_batch_id,sales_orderdetail_batch_id);
CREATE INDEX idx_sales_lookup on fact_orders( order_date_id	
											, due_date_id	
											, ship_date_id 	
											, online_order_id
											, currency_id 	
											, customer_id 	
											, product_id 	);

