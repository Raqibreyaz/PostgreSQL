select * from product where length(sku_code) >= 8;

select length(sku_code) as sku_code_len from product;

select substring('Brother in arms', 3, 4);

select left('Brother Arms', 7);

select right('Brother arms', 2);

select concat(name, category) from product;
select concat_ws(' ', name, category, sku_code) from product;

select length('   brother   ');
select length(trim('   brother   '));

select name, replace(sku_code, left(sku_code, 2), 'GG') from product; 
