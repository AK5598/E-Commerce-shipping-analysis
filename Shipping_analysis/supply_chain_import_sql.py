import pandas as pd
import mysql.connector

# === 1. Database connection config ===
db_config = {
    'host': 'localhost',         # Change if needed
    'user': 'root',
    'password': 'Hysoyam',
    'database': 'supply_chain_problem'
}

# === 2. Excel file path ===
excel_file = 'Supply chain logisitcs problem.xlsx'

# === 3. Sheet name to SQL table mapping and column renaming ===
sheet_mapping = {
    "WhCosts": {
        'table': 'wh_cost',
        'columns': {'WH': 'wh', 'Cost/unit': 'cost_per_unit'}
    },
    "WhCapacities": {
        'table': 'wh_capacity',
        'columns': {'Plant ID': 'plant_id', 'Daily Capacity ': 'daily_capacity'}
    },
    "ProductsPerPlant": {
        'table': 'products_per_plant',
        'columns': {'Plant Code': 'plant_code', 'Product ID': 'product_id'}
    },
    "VmiCustomers": {
        'table': 'vmicustomers',
        'columns': {'Plant Code': 'plant_code', 'Customers': 'customer'}
    },
    "PlantPorts": {
        'table': 'plant_ports',
        'columns': {'Plant Code': 'plant_code', 'Port': 'port'}
    },
    "FreightRates": {
        'table': 'freight_rates',
        'columns': {
            'Carrier': 'carrier',
            'orig_port_cd': 'orgin_port',
            'dest_port_cd': 'destination_port',
            'minm_wgh_qty': 'min_wgh_quantity',
            'max_wgh_qty': 'max_wgh_quantity',
            'svc_cd': 'svc_cd',
            'minimum cost': 'minimum_cost',
            'rate': 'rate',
            'mode_dsc': 'mode_dsc',
            'tpt_day_cnt': 'tpt_day_count',
            'Carrier type': 'carrier_type'
        }
    },
    "OrderList": {
        'table': 'orderlist',
        'columns': {
            'Order ID': 'order_id',
            'Order Date': 'order_date',
            'Origin Port': 'orgin_port',
            'Carrier': 'carrier',
            'TPT': 'tpt',
            'Service Level': 'service_level',
            'Ship ahead day count': 'ship_ahead_day_count',
            'Ship Late Day count': 'ship_late_day_count',
            'Customer': 'customer',
            'Product ID': 'product_id',
            'Plant Code': 'plant_code',
            'Destination Port': 'destination_port',
            'Unit quantity': 'unit_quantity',
            'Weight': 'weight'
        }
    }
}

# === 4. Foreign-key-safe loading order ===
load_order = [
    "WhCosts",
    "WhCapacities",
    "ProductsPerPlant",
    "VmiCustomers",
    "PlantPorts",
    "FreightRates",
    "OrderList"
]

# === 5. Load and insert data ===
def insert_data():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    for sheet_name in load_order:
        mapping = sheet_mapping[sheet_name]
        table = mapping['table']
        column_rename = mapping['columns']

        print(f"Inserting into `{table}` from sheet `{sheet_name}`...")

        df = pd.read_excel(excel_file, sheet_name=sheet_name)
        df = df.rename(columns=column_rename)
        df = df[list(column_rename.values())]  # ensure column order
        df = df.dropna(how='all')  # remove empty rows

        # Handle date formatting
        if 'order_date' in df.columns:
            df['order_date'] = pd.to_datetime(df['order_date']).dt.date

        placeholders = ", ".join(["%s"] * len(df.columns))
        column_names = ", ".join(df.columns)
        insert_query = f"INSERT INTO {table} ({column_names}) VALUES ({placeholders})"

        for row in df.itertuples(index=False):
            try:
                cursor.execute(insert_query, tuple(row))
            except mysql.connector.Error as e:
                print(f"Error inserting into {table}: {e}")
                print(f"Row: {row}")

    conn.commit()
    cursor.close()
    conn.close()
    print("✅ Data inserted successfully into all tables.")

# === 6. Run the script ===
if __name__ == "__main__":
    insert_data()