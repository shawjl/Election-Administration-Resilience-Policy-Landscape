## Election Administration Resilience Policy Landscape Pre-processing
## Tony Molino
# Date 8/5/2024
# This code, for OHIO, deals with removal/protection of appropriate stop words and deals with bi-grams / tri-grams
# loading libraries
library(stringr)
library(quanteda)

# Clearing workspace
rm(list=ls())


df_combined <- readRDS( "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\Data\\State Policies\\final_rule_text_combined_7_24.rds")

# subset to OHIO only

df_OH <- df_combined[grep("^OH", df_combined$bill_title), ]




# Here we should have a section to remove all the unwanted sections because after we will be removing




# Needed punctuation that will be used to identify the sections that need remove
# So after this periods and numbers, including dates will be removed




# Remove words containing numbers or periods before tokenization
df_OH$final_text <- str_remove_all(df_OH$final_text, "\\b\\S*[0-9]+\\S*\\b")
df_OH$final_text <- str_replace_all(df_OH$final_text, "\\b\\S*\\.\\S*\\b", "")


# check some final text out

df_combined[df_OH$bill_title == "OH H 2", "final_text"]

# make the final text as corpus which is the object quanteda can recognize 

corp <- corpus(df_OH , text_field = "final_text")

#bigrams that were identified as relevant but which we do not want to protect. 
# "General assembly",  "Revised code"
# Are there any others?



# List of bigrams to be treated as single units
bigrams_list <- c( "First class", "United States", "County recorder", 
                  "Public official", "Public record", "Voter registration", "Provisional ballot", 
                  "Municipal corporation", "Taxing authority", "Budget commission", 
                  "Property tax", "General election", "Primary election", "Fire district", 
                  "Ballot measure", "Park district", "School district", "County commissioner", 
                  "Independent candidate", "Central committee", "Legislative authority", 
                  "Village clerk", "Probate judge", "Polling place", "Polling location", 
                  "Minority leader", "Electronic pollbook", "Continuing education", 
                  "Chemical dependency", "Election official")

# Customize the stopwords list to exclude 
custom_stopwords <- c(stopwords("english"))
custom_stopwords <- c(custom_stopwords, "Amended", "Enacted", "Section", "Sections", "Revised", "Code", "Bill", "state")





# we remove numbers, punctuation, symbols and seperators

dfm_combined <- tokens(corp, what = 'word',
                       remove_numbers = TRUE, 
                       remove_punct = TRUE, 
                       remove_symbols = TRUE,
                       remove_separators = TRUE) %>%         
  # Convert all tokens to lowercase
  tokens_tolower() %>%
  
  # Include bigrams as unigrams
  tokens_compound(pattern = phrase(bigrams_list)) %>%
  
  # Remove a set of stopwords that are standard in the quanteda package AND additional stop words
  tokens_remove(custom_stopwords) %>%
  
  # Remove tokens with numbers or periods
  tokens_remove(pattern = ".*[0-9].*") %>%
  tokens_remove(pattern = ".*\\..*") %>%
  
  # Remove all words with only one or two characters (e.g., 'a', 'at')
  tokens_select(min_nchar = 3) %>% 
  
  # Create a DFM
  dfm() %>% 
  
  # Stem words
  dfm_wordstem() %>% 
  
  # Remove rare words—those appearing less than 3 times in total and in fewer than 3 documents: My reading of literature is that infruqent tokens should be removed
  # before analysis. Ben Noble sugestted 5-5, but here we do 3-3 because we have only 14 documents. 
  dfm_trim(min_termfreq = 1, termfreq_type = 'count',
           min_docfreq = 1, docfreq_type = 'count')



# Check if bigrams are properly included

bigrams_present <- featnames(dfm_combined)[grepl("_", featnames(dfm_combined))]

print(bigrams_present)


# Check if "Amend" is removed from the DFM
Amend_removed <- !"Amend" %in% featnames(dfm_combined)

print(Amend_removed)

featnames(dfm_combined)

# it would be useful to go through this list of tokens and decide what should not be used.
# for example i think months like stem "novem" should not be included

#save_path <- "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\tony_data_files\\dfm_combined.rds"

# Save the dfm_combined object as an RDS file
# Define the file path where the DFM will be saved
#save_path <- "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\Data\\State Policies\\tony_data_files\\dfm_OH_8_15_24.rds"

# Save the dfm_combined object as an RDS file
#saveRDS(dfm_combined, file = save_path)

