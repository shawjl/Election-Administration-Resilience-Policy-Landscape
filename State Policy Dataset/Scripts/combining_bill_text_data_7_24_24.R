

rm(list=ls())

# Load necessary libraries
library(DBI)
library(RSQLite)

# Define the path to your database file
db_path <- "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/Updated_Bill_Details_wDecodedText_HTMLonly.db"

# Connect to the SQLite database
con <- dbConnect(RSQLite::SQLite(), db_path)

# List all tables in the database
tables <- dbListTables(con)




print(tables)

# Load a specific table (replace 'your_table_name' with the actual table name)
# Example: If you have a table named 'bill_details'
df <- dbReadTable(con, 'bill_details')
print(head(df))

# Remember to disconnect from the database when done
dbDisconnect(con)

rds_path <- "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/tony_data_files/final_data.rds"

# Load the RDS file
df_final_data <- readRDS(rds_path)
# Load necessary libraries
library(dplyr)

# Assuming df and df_final_data have already been loaded as described previously

# Rename the text_content column in df_final_data to final_text
df_final_data <- df_final_data %>%
  rename(final_text = text_content)

# Add a new column 'filetype' to each data frame
df <- df %>%
  mutate(filetype = "other")

df_final_data <- df_final_data %>%
  mutate(filetype = "pdf")

# Select and rename columns to prepare for union
df <- df %>%
  select(bill_id, bill_title, everything(), final_text)

df_final_data <- df_final_data %>%
  select(bill_id, bill_title, everything(), final_text)

# Ensure both data frames have the same column names for the union
df_combined <- bind_rows(df, df_final_data)

# View the combined data frame
print(head(df_combined))


save_path_combined <- "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/final_rule_text_combined_7_24.rds"
save_path_sample <- "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/random_sample_7_24.rds"

# Save the combined data frame to an RDS file
saveRDS(df_combined, save_path_combined)


set.seed(123)  # Setting seed for reproducibility
random_sample <- df_combined %>%
  sample_n(20)

# Save the random sample to an RDS file
saveRDS(random_sample, save_path_sample)
