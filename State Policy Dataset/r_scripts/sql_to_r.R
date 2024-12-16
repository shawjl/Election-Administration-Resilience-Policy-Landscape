
library(RSQLite)



rm(list=ls())


# Define the path to the database
db_path <- "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/billsv2.db"

# Connect to the SQLite database
conn <- dbConnect(SQLite(), dbname = db_path)

# List all tables in the database
tables <- dbListTables(conn)
print("Tables in the database:")
print(tables)

# Read and print the first few rows of the 'billsv2' table
data <- dbReadTable(conn, "billsv2")
print(head(data))

# Close the connection
dbDisconnect(conn)

# some validation


str(data)

# Verify that 'BillText' contains long text data
# Print the length of 'BillText' and a summary of its contents
print(paste("Number of rows in BillText:", length(data$BillText)))
print(summary(nchar(data$BillText)))

# Find the entry with the minimum number of characters in 'BillText'
min_length <- min(nchar(data$BillText))
min_index <- which(nchar(data$BillText) == min_length)

# Print the minimum number of characters and the corresponding string
print(paste("Minimum number of characters in BillText:", min_length))
print("The bill text with the minimum number of characters is:")
print(data$BillText[min_index])




