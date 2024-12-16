## Election Administration Resilience Policy Landscape Pre-processing
## Tony Molino
# Date 8/5/2024
# This code, for OHIO, deals with removal/protection of appropriate stop words and deals with bi-grams / tri-grams

## Part 1: Importing State Policy Dataset
# Use the following command to clear the workspace.
rm(list=ls())

file_path <- "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\Data\\State Policies\\final_rule_text_combined_7_24.rds"

# Load the RDS file
df_combined <- readRDS(file_path)

# subset to OHIO only

df_OH <- df_combined[grep("^OH", df_combined$bill_title), ]

# check some final text out

df_combined[df_combined$bill_title == "OH H 2", "final_text"]

# wgeb put into corpa soemthings are automatically not conisered token. For example /n is not counted as token

### Bag of Words
library(quanteda)
#library(quanteda.corpora)

# Begin by putting the text into a corpus. First, rename columns.
#library(dplyr)


corp <- corpus(df_OH , text_field = "final_text")


# List of bigrams to be treated as single units
bigrams_list <- c("General assembly", "First class", "United States", "County recorder", 
                  "Public official", "Public record", "Voter registration", "Provisional ballot", 
                  "Municipal corporation", "Revised code", "Taxing authority", "Budget commission", 
                  "Property tax", "General election", "Primary election", "Fire district", 
                  "Ballot measure", "Park district", "School district", "County commissioner", 
                  "Independent candidate", "Central committee", "Legislative authority", 
                  "Village clerk", "Probate judge", "Polling place", "Polling location", 
                  "Minority leader", "Electronic pollbook", "Continuing education", 
                  "Chemical dependency", "Election official")

# Customize the stopwords list to exclude "is" and include "Columbus"
custom_stopwords <- setdiff(stopwords("english"), "is")
custom_stopwords <- c(custom_stopwords, "Amend", "Enacted", "Section", "Sections", "Revised", "Code", "Bill", "state")

# Create the DFM
dfm_combined <- tokens(corp, what = 'word') %>% 
  # Group bigrams as single tokens
  tokens_compound(pattern = phrase(bigrams_list)) %>%
  # Remove customized stopwords
  tokens_remove(custom_stopwords) %>%
  # Create a DFM without any other modifications
  dfm()

# Display the DFM
dfm_combined

##### Checking


# Check if bigrams are properly included
bigrams_present <- featnames(dfm_combined)[grepl("_", featnames(dfm_combined))]
print(bigrams_present)

# Check if "is" is retained in the DFM
is_retained <- "is" %in% featnames(dfm_combined)

# Check if "Amend" is removed from the DFM
Amend_removed <- !"Amend" %in% featnames(dfm_combined)


