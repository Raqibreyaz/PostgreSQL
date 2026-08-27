select * from product;

select name, price, 
case when (price > 1000) then 'Expensive'
	when price between 500 and 1000 then 'Moderate'
	else 'Cheap'
end as price_tag from product;

alter table product
add column price_tag text;

update product
set price_tag = 
case
	when (price > 1000) then 'Expensive'
	when price between 500 and 1000 then 'Moderate'
	else 'Cheap'
end;

select name,
case
	when is_available then 'in stock'
	else 'out of stock'
end as availability_status
from product;

select name, stock_quantity,
case 
	when stock_quantity > 100 then 'High Stock'
	when stock_quantity between 30 and 100 then 'Medium Stock'
	else 'Low Stock'
end as label
from product;



