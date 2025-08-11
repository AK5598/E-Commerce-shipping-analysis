create database supply_chain_problem;
use supply_chain_problem;

CREATE TABLE orderlist (
    order_id INT PRIMARY KEY,
    order_date DATE,
    orgin_port VARCHAR(100),
    carrier VARCHAR(100),
    tpt INT,
    service_level VARCHAR(100),
    ship_ahead_day_count INT,
    ship_late_day_count INT,
    customer VARCHAR(100),
    product_id INT,
    plant_code VARCHAR(100),
    destination_port VARCHAR(100),
    unit_quantity INT,
    weight FLOAT,
    FOREIGN KEY (plant_code) REFERENCES wh_cost(wh)
);

-- Table 2: freight_rates
CREATE TABLE freight_rates (
    freight_id INT AUTO_INCREMENT PRIMARY KEY,
    carrier VARCHAR(100),
    orgin_port VARCHAR(100),
    destination_port VARCHAR(100),
    min_wgh_quantity FLOAT,
    max_wgh_quantity FLOAT,
    svc_cd VARCHAR(100),
    minimum_cost FLOAT,
    rate FLOAT,
    mode_dsc VARCHAR(100),
    tpt_day_count INT,
    carrier_type VARCHAR(100)
);

-- Table 3: wh_cost
CREATE TABLE wh_cost (
    wh VARCHAR(100) PRIMARY KEY,
    cost_per_unit FLOAT
);

-- Table 4: wh_capacity
CREATE TABLE wh_capacity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plant_id VARCHAR(100),
    daily_capacity INT,
    FOREIGN KEY (plant_id) REFERENCES wh_cost(wh)
);

-- Table 5: products_per_plant
CREATE TABLE products_per_plant (
    product_id INT,
    plant_code VARCHAR(100),
    PRIMARY KEY (product_id, plant_code),
    FOREIGN KEY (plant_code) REFERENCES wh_cost(wh)
);


-- Table 6: vmicustomers
CREATE TABLE vmicustomers (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    plant_code VARCHAR(100),
    customer VARCHAR(100),
    FOREIGN KEY (plant_code) REFERENCES wh_cost(wh)
);

-- Table 7: plant_ports
CREATE TABLE plant_ports (
    code_id INT AUTO_INCREMENT PRIMARY KEY,
    plant_code VARCHAR(100),
    port VARCHAR(100),
    FOREIGN KEY (plant_code) REFERENCES wh_cost(wh)
);

select * from freight_rates;
select * from orderlist;
select * from plant_ports;
select * from products_per_plant;
select * from vmicustomers;
select * from wh_capacity order by plant_id;
select * from wh_cost;


-----------------plant with highest manufacturing cost as per unit ordered
select plant_code, sum(unit_quantity * cost_per_unit) as total_cost from orderlist as O left join wh_cost as W on O.plant_code = W.wh
group by plant_code
order by total_cost desc;

------------------Which plants are over-utilizing or under-utilizing their warehouse capacity?
select wc.plant_id, sum(o.unit_quantity) as total_units_shipped,
    wc.daily_capacity, (sum(o.unit_quantity) / wc.daily_capacity) as utilization_ratio,
    case
        when (SUM(o.unit_quantity) / wc.daily_capacity) > 1 then 'Over-utilized'
        when (SUM(o.unit_quantity) / wc.daily_capacity) = 1 then 'At capacity'
        else 'Under-utilized'
    end as utilization_status
from orderlist o
join wh_capacity wc 
on o.plant_code = wc.plant_id
group by wc.plant_id, wc.daily_capacity
order by utilization_ratio desc;

-----------------What’s the costliest route (origin port → destination port) based on warehouse cost per unit and shipment volume?
select o.orgin_port, o.destination_port, sum(o.unit_quantity * w.cost_per_unit) as total_route_cost
from orderlist o
join wh_cost w on o.plant_code = w.wh
group by o.orgin_port, o.destination_port
order by total_route_cost desc;


------------------Which carriers are most cost-efficient for each mode of transport?
select mode_dsc, carrier, avg(rate) as avg_rate_per_unit
from freight_rates
group by carrier, mode_dsc
order by mode_dsc, avg_rate_per_unit asc;


---------------------How many products does each plant handle, and which plant has the widest product variety?
select plant_code, count(distinct product_id) as product_variety
from products_per_plant
group by plant_code
order by product_variety desc;

