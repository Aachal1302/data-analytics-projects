import pandas as pd

# Load Table 2 — Checkout Funnel from the Excel file
df=pd.read_excel("../data/raw/PROJECT_DATA.xlsx", sheet_name="Table 2 - Checkout Funnel")
print(df.head())

# Check the number of rows and columns and verify column names
print(df.shape)
print(df.columns)

# Check for missing values in all columns
print(df.isnull().sum())

# Check for completely duplicate rows
print("Duplicate rows :",df.duplicated().sum())

# Check for missing session IDs
print("Missing session IDs :",df["session_id"].isnull().sum())

# Check the data types of all columns
print(df.dtypes)

# Check the unique values in each funnel stage
print(df["visited_website"].unique())

print(df["added_to_cart"].unique())

print(df["checkout_started"].unique())

print(df["purchase_completed"].unique())

print(df["direct_purchase"].unique())


#Count sessions that added a product to cart and those that did not
print(df["added_to_cart"].value_counts())
# Count sessions that started checkout and those that did not
print(df["checkout_started"].value_counts())
# Count sessions that completed a purchase and those that did not
print(df["purchase_completed"].value_counts())
# Count direct purchases and non-direct purchases
print(df["direct_purchase"].value_counts())


# Check whether direct purchases follow the expected funnel logic
print(
    ((df["direct_purchase"] == 1) &
     ((df["viewed_product"] != 1) | (df["added_to_cart"] != 0))).sum()
)


print("Product views:", df["viewed_product"].sum())
print("Direct purchases:", df["direct_purchase"].sum())
print("Added to cart:", df["added_to_cart"].sum())
print("Checkout started:", df["checkout_started"].sum())
print("Purchases:", df["purchase_completed"].sum())



#Check the data types of all columns
print(df.dtypes)
# Check for missing values after cleaning
print(df.isnull().sum())



# Load Table 1 — Sessions
df_table1 = pd.read_excel("../data/raw/PROJECT_DATA.xlsx",sheet_name="Table 1 - Sessions")
# Check whether all Table 2 session IDs exist in Table 1
print(df["session_id"].isin(df_table1["session_id"]).value_counts())



# Calculate product-view sessions that neither added to cart nor directly purchased
product_drop_off = (
    df["viewed_product"].sum()
    - df["added_to_cart"].sum()
    - df["direct_purchase"].sum()
)
print("Product drop-off:", product_drop_off)



# Calculate the product-stage drop-off rate
product_drop_off_rate = (
    product_drop_off / df["viewed_product"].sum()) * 100
print(round(product_drop_off_rate, 2))



# Calculate product viewers who either added to cart or purchased directly
product_to_action = (
    df["added_to_cart"].sum() + df["direct_purchase"].sum())
print("Product viewers who took an action:", product_to_action)


# Calculate the percentage of product viewers who took an action
product_to_action_rate = (
    product_to_action / df["viewed_product"].sum()) * 100
print(round(product_to_action_rate, 2))


#Check for sessions that started checkout without adding to cart
print(((df["checkout_started"] == 1) & (df["added_to_cart"] == 0)).sum())

# Check for purchases without starting checkout
print(((df["purchase_completed"] == 1) & (df["checkout_started"] == 0)).sum())



# Calculate the percentage of sessions that added a product to the cart
add_to_cart_rate = df["added_to_cart"].mean() * 100
print(round(add_to_cart_rate,2))

# Calculate the percentage of sessions that started checkout
checkout_rate = df["checkout_started"].mean() * 100
print(checkout_rate)

# Calculate the percentage of sessions that completed a purchase
purchase_rate = df["purchase_completed"].mean() * 100
print(purchase_rate)


# Calculate the number of sessions lost between adding to cart and starting checkout
drop_off_cart_to_checkout = df["added_to_cart"].sum() - df["checkout_started"].sum()
print(drop_off_cart_to_checkout)

# Calculate the number of sessions lost between starting checkout and completing purchase
drop_off_checkout_to_purchase = df["checkout_started"].sum() - df["purchase_completed"].sum()
print(drop_off_checkout_to_purchase)

# Calculate the percentage drop-off from adding to cart to starting checkout
drop_off_rate_cart_to_checkout = (
    (df["added_to_cart"].sum() - df["checkout_started"].sum())
    / df["added_to_cart"].sum()) * 100
print(round(drop_off_rate_cart_to_checkout,2))


# Calculate the percentage drop-off from starting checkout to completing purchase
drop_off_rate_checkout_to_purchase = (
    (df["checkout_started"].sum() - df["purchase_completed"].sum())
    / df["checkout_started"].sum()) *100
print(round(drop_off_rate_checkout_to_purchase, 2))


# Calculate the overall purchase conversion rate
overall_conversion_rate = (
    df["purchase_completed"].sum() / len(df)) * 100
print(round(overall_conversion_rate, 2))


# Calculate the number of sessions that did not result in a purchase
no_purchase = len(df) - df["purchase_completed"].sum()
print(no_purchase)

# Calculate the overall drop-off rate
overall_drop_off_rate = (no_purchase / len(df)) * 100
print(round(overall_drop_off_rate, 2))



# Save the cleaned Table 2 as a separate Excel file
df.to_excel("table_2_cleaned.xlsx", index=False)
print("Table 2 cleaned file saved successfully.")