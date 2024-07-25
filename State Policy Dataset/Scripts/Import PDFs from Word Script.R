# Load necessary libraries
library(officer)
library(tidyverse)

# Define the path to your Word documents
folder_path <- "C:/Users/tonym/Dropbox/PC (2)/Desktop/word_strickthough_done"

# Ensure the path uses double backslashes for Windows paths
folder_path <- gsub("\\\\", "/", folder_path)

# Function to read text from a Word document
read_word_doc <- function(file_path) {
  doc <- read_docx(file_path)
  text <- docx_summary(doc) %>%
    filter(content_type == "paragraph") %>%
    pull(text) %>%
    paste(collapse = "\n")
  return(text)
}

# Function to extract the string between the third and fourth "-"
extract_string <- function(filename) {
  parts <- str_split(filename, "-")[[1]]
  if (length(parts) >= 4) {
    return(parts[3])
  } else {
    return(NA)
  }
}

# Check if the folder exists
if (!dir.exists(folder_path)) {
  stop("The specified folder does not exist.")
}

# List all Word documents in the folder
files <- list.files(folder_path, pattern = "\\.docx$", full.names = TRUE)

# Check if any files were found
if (length(files) == 0) {
  stop("No .docx files found in the specified folder.")
}

# Create a dataframe with the desired columns
data <- tibble(
  file_name = basename(files),
  extracted_string = sapply(basename(files), extract_string, USE.NAMES = FALSE),
  text_content = sapply(files, read_word_doc, USE.NAMES = FALSE)
)

# Display the dataframe
print(data)

# Display the content of the first document, if available
if (nrow(data) > 0) {
  cat(data$text_content[1])
} else {
  cat("No text content available.")
}

saveRDS(data, file = "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/tony_data_files/data.rds")


# Load the CSV file
csv_data <- read.csv("C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/pdfs_only_7_15.csv")



colnames(data)

take the string between the 4 and fifth 5 csv_data$url_text_final and put that data into a new column called extracted_string

then do a left join with csv_data and data on right by "ectracted_string" (spell that right)






# Load necessary packages
library(dplyr)

# Load the CSV file
csv_data <- read.csv("C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/pdfs_only_7_15.csv")

# Define a function to extract the string between the 4th and 5th '/'
extract_string <- function(x) {
  parts <- unlist(strsplit(x, "/"))
  if (length(parts) >= 6) {
    return(parts[6])
  } else {
    return(NA)
  }
}

# Apply the function to create the extracted_string column
csv_data <- csv_data %>%
  mutate(extracted_string = sapply(url_text_final, extract_string))
csv_data$extracted_string


# Perform a left join with data on extracted_string
merged_data <- left_join(csv_data, data, by = "extracted_string")

##########################

unique(merged_data$extracted_string)
unique(csv_data$extracted_string)
unique(data$extracted_string)
# Confirm the join has been performed
cat("Left join has been performed on 'extracted_string'\n")

# View the first few rows of the merged data
head(merged_data)


















library(dplyr)

# Check for duplicates in extracted_string columns
csv_duplicates <- csv_data %>%
  group_by(extracted_string) %>%
  filter(n() > 1) %>%
  ungroup()

data_duplicates <- data %>%
  group_by(extracted_string) %>%
  filter(n() > 1) %>%
  ungroup()

# View duplicates in csv_data
cat("Duplicates in csv_data:\n")
print(csv_duplicates)

# View duplicates in data
cat("Duplicates in data:\n")
print(data_duplicates)

# Perform the left join again and flag rows with multiple matches
merged_data <- left_join(csv_data, data, by = "extracted_string", suffix = c("_csv", "_data"))

# Identify rows with multiple matches
csv_multiple_matches <- merged_data %>%
  group_by(extracted_string) %>%
  filter(n() > 1) %>%
  ungroup()

# View rows with multiple matches
cat("Rows with multiple matches in the join:\n")
print(csv_multiple_matches)








filter_rows <- function(df) {
  df %>%
    filter(!str_detect(file_name, "\\(1\\)") & substr(file_name, 1, 1) == substr(bill_title, 1, 1))
}

# Apply the filter function to merged_data
filtered_merged_data <- filter_rows(merged_data)

 duplicated_rows <- filtered_merged_data %>%
group_by(extracted_string) %>%
  filter(n() > 1) %>%
  ungroup()

 
 
#### 

 colnames(unique_merged_data)

 
 
 # Load necessary packages
 library(dplyr)
 
 # Remove the specified columns
 final_data <- unique_merged_data %>%
   select(-Open.Link, -extracted_string)
 
 # Save the final data frame as an RDA file with the name bill_pdf_texts_7_17
 save(final_data, file = "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/tony_data_files/bill_pdf_texts_7_17.rda")
 
 # Confirm the data has been saved
 cat("Final data has been saved to C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/tony_data_files/bill_pdf_texts_7_17.rda\n")
 
 # View the first few rows of the final data
 head(final_data)
 
 
 
 
 
 
 rds_file_path <- "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/tony_data_files/bill_pdf_texts_7_17.rds"
 saveRDS(final_data, file = rds_file_path)
 
 
