

-- Stage database: tables targeted by ETL process 101_stage_adventure_works


CREATE TABLE stage_salesorderdetail(
      sales_order_id			INT 			NOT NULL
    , sales_order_detail_id		INT 			NOT NULL
    , order_qty					SMALLINT 		NOT NULL
    , product_id				INT 			NOT NULL
    , special_offer_id			INT 			NOT NULL
    , unit_price				DOUBLE 			NOT NULL
    , unit_price_discount		DOUBLE 			NOT NULL 
    , line_total				DOUBLE 			NOT NULL
    , modified_date				TIMESTAMP
    , row_number 				INT
    , batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_salesorderdetail_batch_id on stage_salesorderdetail(batch_id);
CREATE INDEX idx_stage_salesorderdetail_modified_date on stage_salesorderdetail(modified_date);


CREATE TABLE stage_salesorderheader(
      sales_order_id			INT 			NOT NULL
    , order_date				TIMESTAMP 		NOT NULL
    , due_date					DATETIME 		NOT NULL
    , ship_date					DATETIME 
    , status					TINYINT 		NOT NULL
    , online_order_flag			BIT 			NOT NULL
    , customer_id				INT 			NOT NULL
    , territory_id				INT 
    , ship_method_id			INT 			NOT NULL
    , currency_rate_id			INT 
    , modified_date				TIMESTAMP 		NOT NULL
    , row_number 				INT
    , batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_salesorderheader_batch_id on stage_salesorderheader(batch_id);
CREATE INDEX idx_stage_salesorderheader_modified_date on stage_salesorderheader(modified_date);


CREATE TABLE stage_product(
	  product_id				INTEGER 		NOT NULL
	, name						VARCHAR(150) 	NOT NULL
	, make_flag					BIT 			NOT NULL
	, finished_goods_flag		BIT 			NOT NULL
	, color						VARCHAR(45)
	, standard_cost				DOUBLE			NOT NULL
	, list_price				DOUBLE			NOT NULL
	, size						VARCHAR(15) 
	, size_unit_measure_code	VARCHAR(9)
	, weight_unit_measure_code	VARCHAR(9)
	, weight					DECIMAL 
	, product_line				VARCHAR(6) 
	, class						VARCHAR(6) 
	, style						VARCHAR(6)
	, product_subcategory_id	INTEGER 
	, product_model_id			INTEGER 
	, sell_start_date			DATETIME 		NOT NULL
	, sell_end_date				DATETIME 
	, discontinued_date			DATETIME 
	, modified_date				TIMESTAMP 		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_product_batch_id on stage_product(batch_id);
CREATE INDEX idx_stage_product_modified_date on stage_product(modified_date);


CREATE TABLE stage_specialoffer(
      special_offer_id 			INT 			NOT NULL
    , description				VARCHAR(255) 	NOT NULL
    , discount_pct				DOUBLE 			NOT NULL 
    , type						VARCHAR(50)		NOT NULL
    , category					VARCHAR(50) 	NOT NULL
    , start_Date				DATETIME 		NOT NULL
    , end_Date					DATETIME 		NOT NULL
    , min_qty					INT 			NOT NULL 
    , max_qty					INT 
   	, modified_date 			TIMESTAMP 		NOT NULL
	, row_number  				INT
	, batch_id  				INT
) engine=myisam;
CREATE INDEX idx_stage_specialoffer_batch_id on stage_specialoffer(batch_id);
CREATE INDEX idx_stage_specialoffer_modified_date on stage_specialoffer(modified_date);


CREATE TABLE stage_customer(
	  customer_id				INT				NOT NULL
	, territory_id				INT
	, account_number			VARCHAR(10)		NOT NULL
	, customer_type				VARCHAR(1)		NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_customer_batch_id on stage_customer(batch_id);
CREATE INDEX idx_stage_customer_modified_date on stage_customer(modified_date);


CREATE TABLE stage_salesterritory(
	  territory_id				INT				NOT NULL
	, name						VARCHAR(50)		NOT NULL
	, country_region_code		VARCHAR(3)		NOT NULL
	, sales_group				VARCHAR(50)		NOT NULL
	, sales_ytd					DOUBLE			NOT NULL
	, sales_last_year			DOUBLE			NOT NULL
	, cost_ytd					DOUBLE 			NOT NULL
	, cost_last_year			DOUBLE			NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_salesterritory_batch_id on stage_salesterritory(batch_id);
CREATE INDEX idx_stage_salesterritory_modified_date on stage_salesterritory(modified_date);


CREATE TABLE stage_shipmethod(
	  ship_method_id			INT				NOT NULL
	, name						VARCHAR(50)		NOT NULL
	, ship_base					DOUBLE			NOT NULL
	, ship_rate					DOUBLE			NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id					INT
) engine=myisam;
CREATE INDEX idx_stage_shipmethod_batch_id on stage_shipmethod(batch_id);
CREATE INDEX idx_stage_shipmethod_modified_date on stage_shipmethod(modified_date);


CREATE TABLE stage_currencyrate(
	  currency_rate_id			INT 			NOT NULL
	, currency_rate_date		DATETIME 		NOT NULL
	, from_currency_code		VARCHAR(3)	 	NOT NULL
	, to_currency_code			VARCHAR(3) 		NOT NULL
	, average_rate				DOUBLE
	, end_of_day_rate			DOUBLE
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_currencyrate_batch_id on stage_currencyrate(batch_id);
CREATE INDEX idx_stage_currencyrate_modified_date on stage_currencyrate(modified_date);


CREATE TABLE stage_productsubcategory(
	product_subcategory_id		INT				NOT NULL
	, product_category_id		INT				NOT NULL
	, name						VARCHAR(50)		NOT NULL
	, Modified_Date				TIMESTAMP		NOT NULL
	, row_number				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_productsubcategory_batch_id on stage_productsubcategory(batch_id);
CREATE INDEX idx_stage_productsubcategory_modified_date on stage_productsubcategory(modified_date);


CREATE TABLE stage_productmodel(
	  product_model_id			INT				NOT NULL
	, name						VARCHAR(50)		NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id				 	INT
) engine=myisam;
CREATE INDEX idx_stage_productmodel_batch_id on stage_productmodel(batch_id);
CREATE INDEX idx_stage_productmodel_modified_date on stage_productmodel(modified_date);


CREATE TABLE stage_countryregion(
	  country_region_code		VARCHAR(3) 		NOT NULL
	, name						VARCHAR(50) 	NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_countryregion_batch_id on stage_countryregion(batch_id);
CREATE INDEX idx_stage_countryregion_modified_date on stage_countryregion(modified_date);


CREATE TABLE stage_countryregioncurrency(
	  country_region_code		VARCHAR(3) 		NOT NULL
	, currency_code				VARCHAR(3) 		NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number				 				INT
	, batch_id 									INT
) engine=myisam;
CREATE INDEX idx_stage_countryregioncurrency_batch_id on stage_countryregioncurrency(batch_id);
CREATE INDEX idx_stage_countryregioncurrency_modified_date on stage_countryregioncurrency(modified_date);


CREATE TABLE stage_productcategory(
	  product_category_id		INT				NOT NULL
	, name						VARCHAR(50)		NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_productcategory_batch_id on stage_productcategory(batch_id);
CREATE INDEX idx_stage_productcategory_modified_date on stage_productcategory(modified_date);


CREATE TABLE stage_individual(
	  customer_id				INT				NOT NULL
	, contact_id				INT				NOT NULL
	, demographics				TEXT
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_individual_batch_id on stage_individual(batch_id);
CREATE INDEX idx_stage_individual_modified_date on stage_individual(modified_date);


CREATE TABLE stage_store(
	  customer_id				INT				NOT NULL
	, name 						VARCHAR(50)		NOT NULL
	, sales_person_id			INT				
	, demographics				TEXT
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_store_batch_id 	on stage_store(batch_id);
CREATE INDEX idx_stage_store_modified_date on stage_store(modified_date);


CREATE TABLE stage_storecontact(
	  customer_id				INT				NOT NULL
	, contact_id 				INT 			NOT NULL
	, contact_type_id			INT				
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_storecontact_batch_id 	on stage_storecontact(batch_id);
CREATE INDEX idx_stage_storecontact_modified_date on stage_storecontact(modified_date);

CREATE TABLE stage_contacttype(
	  contact_type_id			INT				NOT NULL			
	, name 						VARCHAR(50)		NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id 					INT
) engine=myisam;
CREATE INDEX idx_stage_contacttype_batch_id 	on stage_contacttype(batch_id);
CREATE INDEX idx_stage_contacttype_modified_date on stage_contacttype(modified_date);


CREATE TABLE stage_contact(
	contact_id					INT				NOT NULL
	, name_style				BIT				NOT NULL
	, title						VARCHAR(9)	
	, first_name				VARCHAR(50)		NOT NULL
	, middle_name				VARCHAR(50)	
	, last_name					VARCHAR(50)		NOT NULL
	, suffix					VARCHAR(10)	
	, email_promotion			INT				NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id		 			INT
) engine=myisam;
CREATE INDEX idx_stage_contact_batch_id on stage_contact(batch_id);
CREATE INDEX idx_stage_contact_modified_date on stage_contact(modified_date);

CREATE TABLE stage_salesperson(
	  sales_person_id			INT				NOT NULL
	, territory_id				INT				
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id		 			INT
) engine=myisam;
CREATE INDEX idx_stage_salesperson_batch_id on stage_salesperson(batch_id);
CREATE INDEX idx_stage_salesperson_modified_date on stage_salesperson(modified_date);


CREATE TABLE stage_salesheaderreason(
	  sales_order_id			INT				NOT NULL
	, sales_reason_id			INT				NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id		 			INT
) engine=myisam;
CREATE INDEX idx_stage_salesheaderreason_batch_id on stage_salesheaderreason(batch_id);
CREATE INDEX idx_stage_salesheaderreason_modified_date on stage_salesheaderreason(modified_date);

CREATE TABLE stage_salesreason(
	  sales_order_id			INT				NOT NULL
	, name						VARCHAR(50)		NOT NULL
	, reason_type				VARCHAR(50)		NOT NULL
	, modified_date				TIMESTAMP		NOT NULL
	, row_number 				INT
	, batch_id		 			INT
) engine=myisam;
CREATE INDEX idx_stage_sales_reason_batch_id on stage_salesreason(batch_id);
CREATE INDEX idx_stage_sales_reason_modified_date on stage_salesreason(modified_date);