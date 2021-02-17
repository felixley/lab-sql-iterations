use sakila;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Write a query to find what is the total business done by each store.
select a.store_id as Store, sum(p.amount) as Amount from payment as p
join staff as a
using (staff_id)
group by a.store_id;

-- Convert the previous query into a stored procedure.
drop procedure if exists task2;

delimiter //
create procedure task2 ()
begin
	select a.store_id as Store, sum(p.amount) as Amount from payment as p
	join staff as a
	using (staff_id)
	group by a.store_id;
end;
// delimiter ;

call task2();

-- Convert the previous query into a stored procedure that takes the input 
-- for store_id and displays the total sales for that store.
drop procedure if exists task3;

delimiter //
create procedure task3 (in param1 int(1))
begin
declare store int(1);
	select a.store_id as Store, sum(p.amount) as Amount from payment as p
	join staff as a
	using (staff_id)
    where a.store_id = param1
	group by a.store_id;
end;
// delimiter ;

call task3(2);

-- Update the previous query. Declare a variable total_sales_value of float type, 
-- that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.
drop procedure if exists task4;

delimiter //
create procedure task4 (in param1 int(1), out param2 float, out param3 int)
begin

declare total_sales_value float DEFAULT 0.0;
declare Store int;

	select round(sum(p.amount),2) into total_sales_value from payment as p
	join staff as a
	using (staff_id)
    where a.store_id = param1
	group by a.store_id;
    
    select store_id into Store
    from staff
    where store_id = param1;
    
    select total_sales_value into param2;
    select store into param3;
end;

// delimiter ;

call task4(2, @x, @y);
select @y as Store, round(@x,2) as total_sales_value;

-- In the previous query, add another variable flag. 
-- If the total sales value for the store is over 30.000, then label it as green_flag, 
-- otherwise label is as red_flag. Update the stored procedure that takes 
-- an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists task5;

delimiter //
create procedure task5 (in param1 int(1), out param2 int, out param3 float(50), out param4 varchar(20))
begin
declare flag varchar(50);
declare total_sales_value float DEFAULT 0.0;

	select round(sum(p.amount),2) into total_sales_value from payment as p
	join staff as a
	using (staff_id)
    where a.store_id = param1
	group by a.store_id;
    
    select total_sales_value;
    case 
		when total_sales_value > 30000 then
			set flag = 'green_flag';
		else
			set flag = 'red_flag';
	end case;
    
    select param1 into param2;
    select total_sales_value into param3;
	select flag into param4;
    
end;
// delimiter ;

call task5(2, @x, @y, @z);
select @x as Store, round(@y,2) as total_sales_value, @z as flag;
