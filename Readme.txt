📦 E-commerce Shipping Analysis
📑 Project Overview
This project analyzes an e-commerce supply chain dataset to uncover operational insights related to shipping, warehouse utilization, carrier efficiency, and product distribution.
The dataset was sourced from Kaggle – Customer Analytics and focuses on costs, capacities, and shipment details, without any sales or revenue data.

The analysis is performed entirely in SQL using a structured relational schema, enabling advanced joins, aggregations, and business-driven insights.

🗂 Dataset & Schema
Database Name: supply_chain_problem

Tables & Relationships
orderlist – Shipment details including origin/destination ports, carrier, product, plant, and weight.

freight_rates – Freight cost rates per carrier, route, and transport mode.

wh_cost – Manufacturing cost per unit for each warehouse/plant.

wh_capacity – Daily capacity for each warehouse/plant.

products_per_plant – Mapping of products handled by each plant.

vmicustomers – Customers served by each plant.

plant_ports – Port assignments for each plant.

Key Relationships:

orderlist.plant_code → wh_cost.wh

wh_capacity.plant_id → wh_cost.wh

products_per_plant.plant_code → wh_cost.wh

vmicustomers.plant_code → wh_cost.wh

plant_ports.plant_code → wh_cost.wh

⚙️ Tech Stack
SQL (MySQL) – Data storage, joins, aggregations, and analysis

Kaggle Dataset – Raw source data

Excel + Python (Pandas) – Data cleaning and initial import into SQL

📊 Key Business Questions & Insights
Plant with Highest Manufacturing Cost: Plant 03
Warehouse Utilization Analysis: Determines whether plants are over-utilized, at capacity, or under-utilized.
Costliest Route (Origin → Destination): Port04 to Port09
Carrier Cost Efficiency by Mode: Highlights which carriers are the most cost-efficient for each mode of transport.
Product Variety per Plant: Reveals which plants handle the widest range of products.

 How to Run the Project
Set up the Database

sql
Copy
Edit
SOURCE supply_chain_problem.sql;
Run the Analysis Queries
Execute each query block in the .sql file to generate insights.