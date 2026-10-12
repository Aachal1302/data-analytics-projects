import pandas as pd

# Load Table 3 — Pricing & Order Details from the Excel file
df=pd.read_excel("../data/raw/PROJECT_DATA.xlsx",sheet_name="Table 3 - Pricing & Orders")
print(df.head())

# Check the number of rows and columns
print(df.shape)
# Check the column names
print(df.columns)

# Check for missing values in each column
print(df.isnull().sum())

# Check for duplicate rows
print(df.duplicated().sum())
# Check for duplicate order IDs
print("Duplicate order IDs:",df["order_id"].duplicated().sum())

# Check the data types of all columns
print(df.dtypes)

# Convert order_date from text to datetime format
df["order_date"]=pd.to_datetime(df["order_date"])
print(df["order_date"].dtype)

# Check the earliest and latest order date
print(df["order_date"].min())
print(df["order_date"].max())


# Check the unique values in categorical columns
print(df["product_category"].unique())
print(df["payment_method"].unique())
print(df["order_status"].unique())

# Check for missing values after cleaning
print(df.isnull().sum())

# Check the basic statistics of numerical columns
print(df[["price", "quantity", "discount", "shipping_cost", "shipping_days", "revenue"]].describe())

# Check how many customer IDs are repeated
print("Duplicate customer IDs:",df["customer_id"].duplicated().sum())
# Check how many product IDs are repeated
print("Duplicate product IDs:", df["product_id"].duplicated().sum())

# Check how many unique products are in the dataset
print("Unique products:", df["product_id"].nunique())


# Check how many orders have each order status
print(df["order_status"].value_counts())
# Check how many orders used each payment method
print(df["payment_method"].value_counts())
# Check how many orders belong to each product category
print(df["product_category"].value_counts())



# Check the minimum and maximum shipping days
print("Minimum shipping days:", df["shipping_days"].min())
print("Maximum shipping days:", df["shipping_days"].max())

# Check the minimum and maximum quantity per order
print("Minimum quantity:", df["quantity"].min())
print("Maximum quantity:", df["quantity"].max())

# Check the minimum and maximum discount
print("Minimum discount:", df["discount"].min())
print("Maximum discount:", df["discount"].max())

# Check the minimum and maximum shipping cost
print("Minimum shipping cost:", df["shipping_cost"].min())
print("Maximum shipping cost:", df["shipping_cost"].max())

# Check the minimum and maximum product price
print("Minimum price:", df["price"].min())
print("Maximum price:", df["price"].max())

# Check the minimum and maximum revenue
print("Minimum revenue:", df["revenue"].min())
print("Maximum revenue:", df["revenue"].max())




# Save the cleaned Table 3 as a separate Excel file
df.to_excel("table_3_cleaned.xlsx", index=False)

print("Table 3 cleaned file saved successfully.")



# Check whether the cleaned Table 3 file exists
import os
print(os.path.exists("../Data/Cleaned/table_3_cleaned.xlsx"))