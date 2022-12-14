create table customer(
    cust_id integer not null,
    cust_name varchar(255),
    contraint pk_cust
    primary key(cust_id)
);

create table pizza_item(
    item_id integer not null,
    item_name varchar(255),
    price integer,
    constraint pk_pizza
    primary key(item_id)
);

create table sale(
    bill_no integer,
    bill_date date,
    cust_id integer not null,
    item_id integer not null,
    qty_sold integer,
    constraint pk_sale
    primary key(cust_id, item_id),
    constraint fk_sale_pizza
    foreign key (item_id) references pizza_item(item_id),
    constraint fk_sale_cust
    foreign key (cust_id) references customer(cust_id)
)

insert into customer values(100, 'ABC');
insert into customer values(101, 'DEF');
insert into customer values(102, 'GHI');
insert into customer values(103, 'JKL');
insert into customer values(104, 'MNO');

insert into pizza_item values(200, 'Chicago Pizza', 1500);
insert into pizza_item values(201, 'XYZ', 2130);
insert into pizza_item values(202, 'JHG', 1640);
insert into pizza_item values(203, 'GUA', 3540);
insert into pizza_item values(204, 'KHG', 2315);

insert into sale values(300, '18-AUG-2022', 100, 201, 3);
insert into sale values(301, '13-MAR-2022', 100, 200, 2);
insert into sale values(302, '17-JUL-2022', 101, 203, 1);
insert into sale values(303, '16-JAN-2022', 102, 204, 5);
insert into sale values(304, '25-DEC-2021', 104, 200, 4);

select *
from pizza_item
where price = (
    select min(price)
    from pizza_item
);

select *
from pizza_item
where price > (
    select avg(price)
    from pizza_item
    group by item_id
);

select bill_no, bill_date, s.cust_id, s.item_id, qty_sold
from sale s, pizza_item p
where p.item_id = s.item_id and
    (qty_sold * price) > 1200;

update pizza_item
set price = 2000
where item_name = 'Chicago Pizza';

select round(avg(qty_sold))
from sale
group by item_id
order by round(avg(qty_sold)) desc;

--6

select cust_name
from customer
where cust_id in (
    select cust_id
    from customer
    group by item_id
    having count(cust_id) = 2
);

create view cust_view
as select cust_name, item_name, bill_no
from customer c, pizza_item p, sale s
where s.item_id = p.item_id and
s.cust_id = c.cust_id;

select cust_id, cust_name
from customer c, sale s
where c.cust_id = s.cust_id and
s.cust_id in (
    select cust_id
    from pizza_item p
    left join sale s
    on s.item_id = p.item_id
);

delete from pizza_item
where item_id not in (
    select item_id
    from sale
);

