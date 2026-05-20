select * from fraud_clean limit 100 ;

select merchant_city , count(*) as missing_zip
from fraud_clean 
where zip ='' 
group by Merchant_City 
order by missing_zip desc ;

select merchant_city , count(*) as missing_state
from fraud_clean 
where Merchant_State ='' 
group by Merchant_City 
order by missing_state desc ;

select is_fraud , count(*) as transactions
from fraud_clean 
where error !='' 
group by is_fraud ;


#fraud Rate by transaction
select use_chip , count(*) as total_transactions ,
sum(
	case 
		when is_fraud ='yes' then 1
        else 0 
        end
	) as fraud_transactions  , 
    
round(
	sum(
	case 
		when is_fraud ='yes' then 1
        else 0 
        end
	) *100 / count(*) , 2 ) as fraud_rate_percentage   
from fraud_clean
group by use_chip 
order by fraud_rate_percentage desc  ;


#creating time period column 
alter table fraud_clean 
add column time_period varchar(20) ; 

update fraud_clean
set time_period =
case 
	when hour(time) between 5 and 11 then 'Morning' 
    when hour(time) between 12 and 16 then 'Afternoon'
    when hour(time) between 17 and 20 then 'evening'
    else 'Night' 
end  ;

select time , time_period from fraud_clean limit 20 ;

# fraud rate by time
select time_period , count(*) as total_transactions ,
sum(
	case 
		when is_fraud ='yes' then 1
        else 0 
        end
	) as fraud_transactions  , 
    
round(
	sum(
	case 
		when is_fraud ='yes' then 1
        else 0 
        end
	) *100 / count(*) , 2 ) as fraud_rate_percentage   
from fraud_clean
group by time_period
order by fraud_rate_percentage desc  ;

#fraud rate by month
select month , count(*) as transactions ,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as fraud_transactions ,

round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        ) *100 /count(*) , 2  )  as fraud_rate_percentage  
from fraud_clean
group by month 
order by fraud_rate_percentage desc ;


#fraud rate by time period and trasanction
select time_period , use_chip ,count(*) as transaction,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as fraud_transactions ,

round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        ) *100 /count(*) , 2  )  as fraud_rate_percentage  
from fraud_clean
group by time_period ,  use_chip 
order by fraud_rate_percentage desc  ;

alter table fraud_clean 
add column amount_num decimal(10,2)  ;

update fraud_clean 
set amount_num =
		cast(replace (amount ,'$' , '') 
			as decimal(10,2) ) ;



#fraud by amount
select is_fraud , count(*) as transactions ,
round(avg(amount_num) , 2) as avg_amount,
round(min(amount_num) , 2) as min_amount,
round(max(amount_num) , 2) as max_amount,
round(sum(amount_num) , 2) as total_amount
from fraud_clean 
group by is_fraud  ;


select merchant_city , count(is_fraud) 
from fraud_clean 
where is_fraud='yes' 
group by merchant_city ;

#fraud rate  by city
select merchant_city ,count(*) as transaction,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as fraud_transactions ,

round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        ) *100 /count(*) , 2  )  as fraud_rate_percentage  
from fraud_clean
group by merchant_city
having count(*)>=20
order by fraud_rate_percentage desc  ;

alter table fraud_clean
add column amount_num_range varchar(20)  ;

update fraud_clean 
set amount_num_range =
	case
		when amount_num <50 then 'Low Value' 
        when amount_num between 50 and 200 then 'Medium Value'
        else 'High Value'
	end
;

select amount_num , amount_num_range 
from fraud_clean limit 20 ;


#Fraud rate by amount range
select amount_num_range ,count(*) as transaction,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as fraud_transactions ,

round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        ) *100 /count(*) , 2  )  as fraud_rate_percentage  
from fraud_clean
group by amount_num_range
order by fraud_rate_percentage desc  ;



#Fraud rate by card type
select card ,count(*) as transaction,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as fraud_transactions ,

round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        ) *100 /count(*) , 2  )  as fraud_rate_percentage  
from fraud_clean
group by card
order by fraud_rate_percentage desc  ;



#Fraud Rate by mcc
select mcc ,count(*) as transaction,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as fraud_transactions ,

round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        ) *100 /count(*) , 2  )  as fraud_rate_percentage  
from fraud_clean
group by mcc
having count(8)>=20
order by fraud_rate_percentage desc  ;


#totals
select count(*) as total_transactions ,
sum( 
	case
		when is_fraud ='yes' then 1
        else 0
	end 
    ) as total_fraud_transactions ,
round(
	sum(
		case
			when is_fraud='yes' then 1
            else 0
		end
        )*100 / count(*),2  )as fraud_rate  ,
round(
	sum(
		case
			when is_fraud='yes' then amount_num
            else 0
		end
        )    ,2 )  as total_fraud_amount 
from fraud_clean  ;


UPDATE fraud_clean
SET error = 'no error'
WHERE error='';

UPDATE fraud_clean
SET zip = 'Unknown'
WHERE zip='';

UPDATE fraud_clean
SET merchant_state = 'Unknown'
WHERE merchant_state ='';


select * from fraud_clean  ;