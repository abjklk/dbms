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

select * from employee;
select * from customer;
select * from part;
select * from orders;
select * from consists_of;
