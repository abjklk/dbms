drop table employee cascade constraints;
create table employee
(
emp_no number primary key,
e_fname varchar(20),
e_lname varchar(20),
z_dist number,
z_post number,
z_region number,
z_subregion number
);

drop table customer cascade constraints;
create table customer
(
cus_no number primary key,
c_fname varchar(20),
c_lname varchar(20),
z_dist number,
z_post number,
z_region number,
z_subregion number
);

create table part
(
part_no number primary key,
quantity number,
price number,
part_name varchar(20) 
);

create table orders
(
order_no number primary key,
date_of_receipt date,
expected_sdate date,
actual_sdate date,
emp_num number,
cus_num number,
foreign key(emp_num) references employee(emp_no),
foreign key(cus_num) references customer(cus_no) 
);

create table consists_of
(
order_num number references orders(order_no),
part_num number references part(part_no),
quantity number,
primary key(order_num,part_num)
);


insert into employee values(10,'Samanth','Kulkarni',5,5,810,2);
insert into employee values(20,'Sanjay','Patil',6,4,311,3);
insert into employee values(30,'Rajesh','Desai',8,3,112,7);
insert into employee values(40,'Ramesh','Shetty',4,8,213,9);
insert into employee values(50,'Digvijay','Deshpande',9,5,714,1);
insert into employee values(60,'Sanjana','Deshmukh',5,3,615,2);

insert into customer values(10,'Samanth','Biradar',1,2,316,4);
insert into customer values(11,'Umesh','Pawar',6,4,317,3);
insert into customer values(12,'Arpita','Agarwal',9,3,118,2);
insert into customer values(13,'Arnav','Singh',6,2,119,1);
insert into customer values(14,'Yash','Patil',2,1,920,8);
insert into customer values(15,'Preeti','Mehta',1,2,121,9);

insert into part values(1219,10,500,'abc');
insert into part values(1130,20,600,'xyz');
insert into part values(1782,30,700,'abx');
insert into part values(1090,40,800,'cbz');
insert into part values(2199,50,900,'ddr');
insert into part values(5219,60,1000,'nms');

insert into orders values(2682,'12-aug-2015','14-aug-2015','17-aug-2015',10,10);
insert into orders values(1231,'10-mar-2015','15-mar-2015','15-mar-2015',20,13);
insert into orders values(1090,'15-aug-2017','20-aug-2017','24-aug-2017',20,11);
insert into orders values(2145,'29-sep-2016','29-mar-2019','31-mar-2019',30,12);
--delete from orders where emp_num=30;
insert into orders values(3214,'13-feb-2018','18-feb-2018','18-feb-2018',40,14);
insert into orders values(2188,'10-mar-2019','17-mar-2019','20-mar-2019',50,15);


insert into consists_of values(2682,1219,3);
insert into consists_of values(2682,1130,4);
insert into consists_of values(1231,1130,1);
insert into consists_of values(1090,1782,2);
insert into consists_of values(2145,1090,3);
--delete from consists_of where order_num=2145;
insert into consists_of values(3214,2199,4);
insert into consists_of values(2188,5219,5);


select * from employee;
select * from customer;
select * from part;
select * from orders;
select * from consists_of;

--                          Simple Queries                         --
-- Q1 retrive all the employee details whose first name is Rajesh and shipped an order last week.

select *
from employee,orders,customer
where e_fname='Rajesh' and employee.emp_no=orders.emp_num and customer.cus_no=orders.cus_num 
and ((select sysdate from dual)-actual_sdate)<7;

--Q2 retrieve the name of the employee who has taken the order with order number 3214.

select e_fname,e_lname
from employee,orders
where emp_num=emp_no and order_no = 3214;

-- Q3 retrieve all the employee details whose id is 10 and taken an order yesterday.

select *
from employee,orders,customer
where employee.emp_no=orders.emp_num  and customer.cus_no=orders.cus_num and employee.emp_no = 10
and to_char(date_of_receipt,'DD') - to_char(sysdate,'DD') = 1;

-- Q4  retrieve the customer and order details of the order that was shipped on 17-8-15.

select cus_no,c_fname,c_lname,order_no,actual_sdate
from customer,orders
where customer.cus_no=orders.cus_num and orders.actual_sdate like '17-AUG-15';

--Q5 retrive orders with expected ship date same as the actual ship date and customer district same as employee district.

select order_no,date_of_receipt,expected_sdate,orders.actual_sdate
from orders,employee,customer
where orders.actual_sdate = orders.expected_sdate and emp_no=emp_num and cus_no=cus_num 
and customer.z_dist=employee.z_dist;


 --                      aggregate 
 
--Q6 Net Worth of all parts available in the shop.

select part_no,part_name,(price*quantity) worth
from part
group by part_name,part_no,(price*quantity)
order by(worth);

--Q7 List the parts which has availability of more than 30 pieces in descending order.

select * 
from part
where quantity > 30
order by quantity DESC;


-- Q8 Retrieve the total number of customers in district no. 6.

select count(z_dist) total_district
from customer
where z_dist=6
group by z_dist;

-- Q9A Find the total number of employees

select count(*) Employee_count
from employee;


--Q10 Retrive the top 3 costliest part details.
select * 
from (select part_no,part_name,price
      from part
      order by price DESC)
where ROWNUM<=3;


--                             Nested                 --

--Q11 Retrieve all the order numbers which had the part nms.

select order_num
from consists_of
where part_num in ( select part_no 
                    from part
                    where part_name='nms');


--Q12 Retrieve the employee details who took the order which had the part xyz.

select * 
from employee
where emp_no in (select emp_num
                 from orders
                 where order_no in (select order_num
                                    from consists_of
                                    where part_num in ( select part_no 
                                                        from part
                                                        where part_name='xyz')));                


-- Q13 retrieve all the orders taken by employee with first name 'ramesh' 

select *
from orders
where orders.order_no in (select orders.order_no 
                          from orders,employee
                          where employee.emp_no=orders.emp_num and employee.e_fname='Ramesh');

--Q14 retrive orders which were shipped after 5 days and had more than 5 items

select * 
from orders 
where (actual_sdate=(date_of_receipt+5))and order_no in( select order_num
                                                         from consists_of
                                                         group by order_num
                                                         having sum(quantity)>5);

--Q15 Retrieve orders consisting of more than 1 parttype

select * 
from orders 
where order_no in ( select order_num
                    from consists_of
                    group by order_num
                    having count(*)>1);

--                          Correlated           --

-- Q16 retrieve the information for parts which have not been ordered

 select * 
 from part p
 where not exists (select * from consists_of
                   where p.part_no=part_num );

--Q17  retrieve employee details who are not taking any orders

 select * 
 from employee e
 where not exists (select * from orders where emp_num=e.emp_no);
              

--Q18 Employees who have shipped the order within 5 days of receipt

 select * 
 from employee e
 where  exists (select * from orders
                where ((actual_sdate-date_of_receipt)<=5) and e.emp_no=emp_num );
                

--Q19 For each part retrieve part name and price where more than 3 pieces were ordered in a single order.

 select part_no,price 
 from part p
 where  exists (select * from consists_of c
                where c.quantity>3  and p.part_no=c.part_num ); 
                
--Q20 List of employees who shipped a order on expected date

select * 
from employee
where emp_no in(select emp_num
                from orders
                where expected_sdate=actual_sdate); 
                
--                           Queries on Views                      -- 

create view orderworth
as (select order_no,sum(c.quantity*p.price)as worth
from part p,orders o,consists_of c
where p.part_no=c.part_num and c.order_num=o.order_no
group by order_no
);

create view orderitemcount
as (select order_no,sum(c.quantity)as itemcount
    from part p,orders o,consists_of c
    where p.part_no=c.part_num and c.order_num=o.order_no
    group by order_no
   );

create view partdemand
as(select part_no,sum(c.quantity)as orderednum
from part p,orders o,consists_of c
where p.part_no=c.part_num and c.order_num=o.order_no
group by part_no
);

create view efficientemployee
as (select * 
    from employee e
    where  exists (select * from orders
                    where ((actual_sdate-date_of_receipt)<=5) and e.emp_no=emp_num ));
                
                
select * from orderworth;
select * from partdemand;
select * from orderitemcount;
select * from efficientemployee;


--Q21 retrieve customers who have placed orders worth more than 3000 with order no and its price

select c_fname,cus_no,o.order_no,w.worth
from orders o,orderworth w,customer e
where o.order_no=w.order_no and e.cus_no=o.cus_num and worth>3000;


--Q22 retrieve employees who have shipped order within 5 days consisting atleast 5 items
select e_fname,emp_no,o.order_no,w.itemcount
from orders o,orderitemcount w,efficientemployee e
where o.order_no=w.order_no and e.emp_no=o.emp_num and itemcount>=5;

--Q23 retrieve orders worth more than average price of orders

select *
from orderworth 
where worth>(select avg(worth)
             from orderworth);
 
 --Q24 employee who has taken more than 1 order and is efficient(shipped within 5 days)

select emp_no,e_fname
from efficientemployee
where emp_no in(select emp_num from orders 
                group by emp_num 
                having count(*)>1);
 
--Q25 retrieve orders which consists of parts which is top in demand

select c.order_num
from consists_of c,partdemand d
where c.part_num=d.part_no and orderednum=(select max(orderednum)
                                           from partdemand);

