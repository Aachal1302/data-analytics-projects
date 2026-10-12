import pandas as pd

# Load the Excel file into a DataFrame
df = pd.read_excel("../data/raw/PROJECT_DATA.xlsx")

# Display the first 5 rows, dataset size, column names, and missing values
print(df.head())
print(df.shape)
print(df.columns)
print(df.isnull().sum())


# Check for duplicate rows and duplicate session IDs
print("Duplicate rows:", df.duplicated().sum())
print("Duplicate session IDs:", df["session_id"].duplicated().sum())


# Check the data types of all columns
print(df.dtypes)


# Convert session_date from text to datetime format
df["session_date"] = pd.to_datetime(df["session_date"])
# Verify the converted data type
print(df["session_date"].dtype)


# Replace missing campaign_type values with "Unknown"
df["campaign_type"] = df["campaign_type"].fillna("Unknown")
# Verify that campaign_type has no missing values
print(df["campaign_type"].isnull().sum())


# Check unique values in categorical columns
print(df["campaign_type"].unique())
print(df["device_type"].unique())
print(df["customer_type"].unique())
print(df["location"].unique())
print(df["traffic_channel"].unique())


# Recheck missing values after cleaning
print(df.isnull().sum())


# Check the distribution of categorical values
print(df["device_type"].value_counts())
print(df["customer_type"].value_counts())
print(df["location"].value_counts())
print(df["traffic_channel"].value_counts())


# Check for duplicate customer IDs
print("Duplicate customer IDs:", df["customer_id"].duplicated().sum())


# Check the date range of the dataset
print("Start date:", df["session_date"].min())
print("End date:", df["session_date"].max())


# Check for invalid or missing session dates
print("Missing session dates:", df["session_date"].isnull().sum())
print("Invalid dates:", df["session_date"].isna().sum())


# Check for missing customer IDs
print("Missing customer IDs:", df["customer_id"].isnull().sum())

# Check for missing session IDs
print("Missing session IDs:", df["session_id"].isnull().sum())

# Check for missing traffic channel values
print("Missing traffic channels:", df["traffic_channel"].isnull().sum())

# Check for missing device type values
print("Missing device types:", df["device_type"].isnull().sum())

# Check for missing customer type values
print("Missing customer types:", df["customer_type"].isnull().sum())

# Check for missing location values
print("Missing locations:", df["location"].isnull().sum())

# Check for missing campaign type values
print("Missing campaign types:", df["campaign_type"].isnull().sum())

# Final check for missing values in all columns
print(df.isnull().sum())

# Verify the final dataset size
print("Final dataset shape:", df.shape)


# Save the cleaned Table 1 as a separate Excel file
df.to_excel("table_1_cleaned.xlsx", index=False)

print("Table 1 cleaned file saved successfully.")

# Check whether the cleaned Table 1 file exists
import os

print(os.path.exists("../Data/Cleaned/table_1_cleaned.xlsx"))