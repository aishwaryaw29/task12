select * from sales

Create table Report_Table(
	product_id varchar primary key,
	sum_of_sales float ,
	sum_of_profit float 
	)

create or replace function update_product_report()
RETURNS trigger as $$
declare 
	sumOfSales float;
	sumOfProfit float;
	count_report int;
BEGIN
	select sum(sales) , sum(profit) into sumOfSales, sumOfProfit from sales 
	where product_id = NEW.product_id;

	select count(*) into count_report from Report_Table where product_id=NEW.product_id;

	if count_report = 0 THEN
	insert into Report_Table values (NEW.product_id, sumOfSales,sumOfProfit);
	else
		update Report_Table set  sum_of_sales = sumOfSales, sum_of_profit = sumOfProfit
		where  product_id=NEW.product_id;
	end if;
	REturn NEw;
END
$$ Language plpgsql

create trigger update_report_trigger
After insert on sales
for each row
execute function update_product_report()

