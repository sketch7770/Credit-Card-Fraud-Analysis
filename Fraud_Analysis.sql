#create Schema
create schema fraud_analysis ;
use fraud_analysis;

#create table
create table credit_card(
User INT,
Card int ,
Year int,
Month int ,
Day int ,
Time  time,
Amount varchar(20) ,
Use_Chip varchar(20) ,
Merchant_Name	varchar(50) ,
Merchant_City	varchar(20) ,
Merchant_State  varchar(20) ,
Zip varchar(20) ,
MCC int,
Error varchar(50) ,
Is_Fraud varchar(10) 
);

#load data
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_card_transactions.csv"
INTO TABLE credit_card
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows ;

select * from credit_card  limit 100 ;
describe credit_card;
select count(*) from credit_card;

#checking null values
select 
count(*) as zip_not_null 
  from credit_card 
  where zip != '' ;
  
select 
count(*) as Merchant_State_not_null 
  from credit_card 
   where Merchant_State != '' ;
   
     select 
count(*) as error_not_null 
  from credit_card 
  where error != '' ;
   
   
#checking fraud distribution
  select is_fraud , 
  count(*) as total
  from credit_card
  group by is_fraud ;
 
#checking transaction method distribution
 select use_chip , 
  count(*) as total
  from credit_card
  group by use_chip ;
  
  #checking duplicates
  select user , Card	,Year,Month,Day,Time,Amount , count(*) as total 
  from credit_card 
  group by User	,
  Card	,
  Year,
  Month,
  Day,
  Time,
  Amount 
  having count(*)>1  ;

select distinct Merchant_City , count(Merchant_City) from credit_card 
where Merchant_City  = 'online' ;

select merchant_city , is_fraud , count(*) as total 
from credit_card 
where merchant_city ='online'
group by Merchant_City , Is_Fraud  ;

SELECT DISTINCT use_chip
FROM credit_card;

create table fraud_clean as
select * from credit_card  ;

alter table credit_card rename to fraud_data ;