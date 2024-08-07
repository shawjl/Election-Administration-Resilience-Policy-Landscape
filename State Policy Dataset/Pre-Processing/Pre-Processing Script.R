## Election Administration Resilience Policy Landscape Pre-processing
## Tony Molino and Jake Shaw
## DRAFT: This code is adapted from the first two lectures from IQMR. Most commands are
## fully formatted for this dataset. After approx. line 150, more work needs to
## be done.

## Part 1: Importing State Policy Dataset
# Use the following command to clear the workspace.
rm(list=ls())

# Install the RSQLite package to access the database file from SQLite.
# install.packages("RSQLite")
library(RSQLite)

# Define the path to the database - NOTE: this will need to be changed depending
# on your operating system and file structure.



# db_path <- "/Users/jakeshaw/Downloads/billsv2.db"



db_path <-  "C:/Users/tonym/Box/Election Administration Resilience & Policy Landscape/Data/State Policies/Archived Datasets/billsv2.db"








# Connect to the SQLite database
conn <- dbConnect(SQLite(), dbname = db_path)


## Part 2: Exploring the dataset
# List all tables in the database
tables <- dbListTables(conn)
print("Tables in the database:")
print(tables)

# Read and print the first few rows of the 'billsv2' table
data <- dbReadTable(conn, "billsv2")
print(head(data))

# Close the connection
dbDisconnect(conn)

## Part 3: Some Validation

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

## Part 4: Pre-Processing
# Convert bill text (variable BillText) to lowercase characters
library(tidyverse)

data <- data %>% 
  mutate(BillText = as.character(BillText))

# NOTE: substitute data_lower with data if you want to commit to this change
# and simplify subsequent steps
data_lower <- data %>% 
  mutate(BillText = tolower(BillText))

View(data_lower$BillText)

### Bag of Words
library(quanteda)
library(quanteda.corpora)

# Begin by putting the text into a corpus. First, rename columns.
library(dplyr)



data <- data %>%
  rename(BillText = text_field)




corp <- corpus(data, text_field = "BillText")

# Now that the text is recognized as a corpus, we can tokenize the corpus, 
# indicate that we are looking for single words (called unigrams), and remove
# certain features like numbers, punctuation, symbols, and separators. The 
# "what" is what signifies that it is a unigram. NOTE: remove any commands that 
# take out characters you'd like to remain.
corp_bow <- tokens(corp, what = 'word',
                 # here, we remove several types of tokens we do not want, including 
                 # numbers, punctuation, symbols, and separators.
                 # QUESTION: is there any concern about removing some of these character
                 # types from our corpus?
                 remove_numbers = TRUE, 
                 remove_punct = TRUE, 
                 remove_symbols = TRUE,
                 remove_separators = TRUE) %>% 
  # we convert all tokens to lowercase
  tokens_tolower() %>%
  # we remove a set of stopwords that are standard in the quanteda package
  tokens_remove(c(stopwords("english"))) %>%
  # we remove all words with only one or two characters (e.g., 'a', 'at')
  tokens_select(min_nchar = 3) %>% 
  # we create a dfm
  dfm() %>% 
  # we stem words
  dfm_wordstem() %>% 
  # we remove rare words---those appearing less than 5 times in total and
  # those that appear in fewer than five documents
  dfm_trim(min_termfreq = 5, termfreq_type = 'count',
           min_docfreq = 5, docfreq_type = 'count')

# we can preview our dfm now after having applied all of these steps
# QUESTION: What are some key statistics you notice about this dfm?
corp_bow

# To count specific keywords, insert a word of interest between the apostrophes
# below. For example, 'election.' There are 161 references to the word 'election'
sum(corp_bow[,'election'])

# *** Come back to this once you format/conceptualize date correctly
# We could run a simple regression using our keyword. One hypothesis is that as
# we get farther away from the 2016 election, Trump is less likely to reference
# Clinton.

# We can extract the number of references to Clinton from our dfm
clinton_ref <- convert(tt_dfm[,'clinton'], 'data.frame')[,2]
# We can convert the time the tweet was sent into a year variable, subtract
# 2016 to determine how many years away we are from the election.
years_since_election <- year(docvars(tt_dfm)$time) - 2016
# We perform our regression and see that for every year we get farther away
# from the 2016 election, the number of clinton references in a Trump tweet 
# declines by about 0.008 on average.
summary(lm(clinton_ref ~ years_since_election))

# *** end of come back ***

# We have many other options when it comes to creating our dfm. As one example:
corp_bow2 <- tokens(corp, what = 'word',
                  remove_numbers = TRUE, 
                  remove_punct = TRUE, 
                  remove_symbols = TRUE,
                  remove_separators = TRUE) %>% 
  tokens_tolower() %>%
  # we remove a set of stopwords that are standard in the quanteda package
  # and custom stopwords (perhaps Trump's opponents?)
  tokens_remove(c(stopwords("english"), 'clinton', 'biden')) %>%
  # we can include all unigrams and bigrams after removing some features and
  # after removing stopwords 
  tokens_ngrams(n = 1:2) %>% 
  tokens_select(min_nchar = 3) %>% 
  dfm() %>% 
  # we remove more words than we did previously
  dfm_trim(min_termfreq = 50, termfreq_type = 'count',
           min_docfreq = 50, docfreq_type = 'count')

# here, we can preview some of the features in our dfm.
featnames(corp_bow2)
# I will let you discover other options on your own---there are many ways to 
# do this pre-processing.

# We will come back to the dfm later in today's class as well as in future 
# classes, but there may actually be more convenient ways to do dictionary and
# keyword counting in R than relying on dfms.

# We can also count the number of "Clinton 'election' references without formatting our
# data as a dfm using the `str_count()` command from the `stringi` package.
library(stringi)

election_ref_df <- data %>% 
  # lowercase text (always good to do)
  mutate(BillText = tolower(BillText),
         # search for clinton references, format is text_col, text pattern
         election_ref = str_count(BillText, 'election'),
         # create years since election
         years_since_election = year(time) - 2016)
# ***reformat date here

# We can see the number of references we found
table(election_ref_df$election_ref)
# Same regression as above, and we get the same results
summary(lm(election_ref ~ years_since_election, election_ref_df))

# Note that `str_count()` will capture some word stems. For example, it will
# count both 'republican' and 'republicans' when you search for 'republican'
example_text = 'The republican party is made up of republicans.'
str_count(example_text, 'republican') == 2

# Let's try to replicate my dictionary based sentiment analysis from lecture in
# this data set. 

# We can access the afinn dictionary from the `tidytext` package.
library(tidytext)
# This is a data frame of words and sentiment scores
afinn_dict <- get_sentiments('afinn')
# let's give each text a unique id number
clinton_ref_df$unique_id <- 1:nrow(trump_tweets)
# starting from our original data
trump_words <- clinton_ref_df %>% 
  # this function takes the output column name (word) and input column of 
  # text (text) and then tokenizes words
  unnest_tokens(word, text)

trump_sentment <- trump_words %>% 
  # merge the sentiment dictionary with our words
  left_join(afinn_dict) %>% 
  # code all missing words as 0 sentiment since they aren't in the dictionary
  mutate(value = if_else(is.na(value), 0, value))

trump_score_df <- trump_sentment %>% 
  # aggregate by grouping relevant variables together (unique_id is most 
  # important here)
  group_by(id, time, url, unique_id, clinton_ref, years_since_election) %>% 
  # sum values by tweet
  summarise(tot_score = sum(value), 
            # count number of total words (including 0s)
            word_count = n()) %>% 
  # create the score by dividing the total score by the number of words
  mutate(sent_score = tot_score / word_count)

# are speeches referencing clinton more negative than those not?
summary(lm(sent_score ~ clinton_ref, trump_score_df))
# yes---speeches referencing clinton are about 0.07 points more negative!

## Part II: Your Turn!
# Starting with the original df of tweets, `trump_tweets` do the following 
# (using what I have given you as a model). 

# 1) Create a dfm with the following characteristics:
# - unigrams
# - remove punctuation, symbols, and separators, but _not_ numbers
# - convert tokens to lowercase
# - remove stopwords from quanteda
# - remove all letters (single character words) 
# - stem the words
# - trim the corpus so that you keep all words that appear at least 10 times
#   and those that appear across at least 5 tweets

tt_corp_ex <- corpus(trump_tweets)

tt_dfm_ex <- tokens(tt_corp_ex, what = 'word',
                    # here, we remove several types of tokens we do not want, including 
                    # punctuation, symbols, and separators, but not numbers
                    remove_numbers = FALSE, 
                    remove_punct = TRUE, 
                    remove_symbols = TRUE,
                    remove_separators = TRUE) %>% 
  # we convert all tokens to lowercase
  tokens_tolower() %>%
  # we remove a set of stopwords that are standard in the quanteda package
  tokens_remove(c(stopwords("english"))) %>%
  # we remove all words with only one character
  tokens_select(min_nchar = 2) %>% 
  # we create a dfm
  dfm() %>% 
  # we stem words
  dfm_wordstem() %>% 
  # we remove rare words---those appearing less than 10 times in total and
  # those that appear in fewer than five tweets
  dfm_trim(min_termfreq = 10, termfreq_type = 'count',
           min_docfreq = 5, docfreq_type = 'count')

# 2) What is N, J, and the sparsity of the dfm?

# N = 23,073 (the number of documents), J = 3,550 (the number of unique 
# features), and the sparsity is 99.63% (the percentage of cells that are 0).

# 3) How often does Trump reference immigration? Let's suppose we can capture
# all references to immigration using the stem 'immigr' and the stem 'border'.

# extract columns with features immigr and border, sum the totals
sum(tt_dfm_ex[,c('immigr', 'border')])

# 4) Using the original data, `trump_tweets`, create a new df where you use 
# `str_count()` to count instances of both 'immigr' (note, this will capture 
# complete words like 'immigrant' and 'immigration') and 'border'. Don't forget 
# to lowercase the text! 
# Hint: it might be easier to do this is multiple steps. First, count the 
# number of 'immigr' references in a variable, then the number of 'border' 
# references, and finally, add those two variables together for the final 
# count.

immig_df <- trump_tweets %>% 
  # lowercase text
  mutate(text = tolower(text),
         # count 'immigr' references
         immigr = str_count(text, 'immigr'),
         # count 'border' references
         border = str_count(text, 'border'),
         # add both reference types into a single variable
         all_ref = immigr + border)


# 5) Using the tidytext method, convert the you just created to one where each
# row is a word within a document. Before you do this, create unique document
# ids! 

# assign unique id
immig_df$unique_id <- 1:nrow(immig_df)

immig_toks <- immig_df %>% 
  # create unigrams
  unnest_tokens(word, text) 

# 6) The NRC dictionary contains a df of words and emotion codes, including 
# anger. The code below will read in that dictionary and subset just to anger
# words. Merge this dictionary with the tweet data and aggregate back to the 
# document level counting the proportion of anger words per words in tweets. 
# When you group, make sure to include the unique_id and the category that 
# counts all immigration references. Also make sure to convert NA (non-anger)
# words to 0s!

# read in nrc dictionary and filter to anger words
nrc_anger <- get_sentiments('nrc') %>% 
  filter(sentiment == 'anger')

anger_df <- immig_toks %>% 
  # merge the nrc anger dict
  left_join(nrc_anger) %>% 
  # convert NAs to 0s
  mutate(anger = if_else(is.na(sentiment), 0, 1)) %>% 
  # grouping variables
  group_by(unique_id, time, url, all_ref) %>% 
  # compute the total anger per tweet and total word count
  summarise(n_anger = sum(anger), wc = n()) %>% 
  # create the proportion of anger words in a tweet
  mutate(anger_pct = n_anger / wc)

# 7) Run a regression to test whether tweets that reference immigration more 
# are angrier on average. What do you conclude?

summary(lm(anger_pct ~ all_ref, anger_df))
# For each additional immigration reference, the proportion of anger words used
# in a tweet is 0.5% higher.

# 8) (Time-permitting) Our measure of immigration references is probably 
# imperfect. As a class, let's try to assess how it performs. Run the code 
# below. It will create a csv file on your desktop. Read through each tweet and
# determine whether it is or isn't about immigration. If so, add a 1 to the 
# column named `true_immigr`, otherwise put a 0 in this column. If you finish
# email me the csv that includes the codes you added.

# randomly sample 10 immigration rows and 10 non-immigration rows
immig_val <- bind_rows(
  immig_df %>% filter(all_ref == 1) %>% sample_n(20),
  immig_df %>% filter(all_ref == 0) %>% sample_n(20)
) %>% 
  # create an empty column for coding
  mutate(true_immigr = NA_real_)
# subset to relevant variables
select(time, text, all_ref, true_immigr)

# write validation set to csv
write_csv(immig_val, '~/Desktop/immig_val.csv')



