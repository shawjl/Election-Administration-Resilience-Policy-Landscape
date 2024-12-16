## Election Administration Resilience Policy Landscape Pre-processing
## Tony Molino
# Date 8/24/2024
# This code for all 12 states deals with all pre-processing 
# loading libraries
library(stringr)
library(quanteda)

# Clearing workspace
rm(list=ls())


df_combined <- readRDS( "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\Data\\State Policies\\final_rule_text_combined_7_24.rds")

# subset to OHIO only (Comented out now)

# df_combined <- df_combined[grep("^OH", df_combined$bill_title), ]

# Here we should have a section to remove all the unwanted sections because after we will be removing

# Needed punctuation that will be used to identify the sections that need remove

# So after this periods and numbers, including dates will be removed




# Remove words containing numbers or periods before tokenization
df_combined$final_text <- str_remove_all(df_combined$final_text, "\\b\\S*[0-9]+\\S*\\b")
df_combined$final_text <- str_replace_all(df_combined$final_text, "\\b\\S*\\.\\S*\\b", "")


# check some final text out

#df_combined[df_combined$bill_title == "OH H 2", "final_text"]

# make the final text as corpus which is the object quanteda can recognize 

corp <- corpus(df_combined , text_field = "final_text")

#bigrams that were identified as relevant but which we do not want to protect. 
# "General assembly",  "Revised code"
# Are there any others?



# List of bigrams to be treated as single units
bigrams_list <- c(
  "First class", "United States", "County recorder", "Public official", "Public record", 
  "Voter registration", "Provisional ballot", "Municipal corporation", "Taxing authority", 
  "Budget commission", "Property tax", "General election", "Primary election", "Fire district", 
  "Ballot measure", "Park district", "School district", "County commissioner", "Independent candidate", 
  "Central committee", "Legislative authority", "Village clerk", "Probate judge", "Polling place", 
  "Polling location", "Minority leader", "Electronic pollbook", "Continuing education", 
  "Chemical dependency", "Election official", "City Clerk", "Town Clerk", "County Officer", 
  "early ballot", "late mailing", "registered voter", "municipal legislation", "presidential electors", 
  "electoral college", "state committee", "political party", "nomination paper", 
  "affidavit of qualification", "replacement elector", "federal form", "election assistance", 
  "state-specific instructions", "proof of", "official ballots", "election day", "voting system", 
  "peace officer", "home address", "court order", "personal information", "confidentiality program", 
  "County board", "Polling places", "Mail-in", "Two thousand", "One hundred", "One thousand", 
  "Five hundred", "Six inches", "Four inches", "Election officer", "Election district", "Paper ballots", 
  "Voting booth", "Tabulation equipment", "Spoiled ballots", "District attorney", "Absentee voters", 
  "Absentee ballot", "Voting machines", "Lieutenant governor", "Election audits", "Taxpayer-funded", 
  "Single vote", "In person", "Valid identification", "Independent auditor", "Constitutional amendment", 
  "Ballot question", "Nomination petitions", "election precincts", "early voting", "voting centers", 
  "voting mark", "straight party", "optical scan", "electronic voting", "local offices", "ballot card", 
  "absentee ballots", "district elections", "disaster emergency", "party positions", "enrolled voters", 
  "ward town", "county committee", "amend election", "voting rights", "rights act", 
  "protected class", "language-minority groups", "voter intimidation", "election law", 
  "providing assistance", "legal residence", "valid address", "valid addresses", "residential address", 
  "residential addresses", "vote-by-mail", "supervisor elections", "voter certificate", 
  "mailing envelope", "election results", "write-in candidates", "section repealed", 
  "residency requirements", "political advertisement", "electioneering communication", 
  "miscellaneous advertisement", "generative artificial", "artificial intelligence", 
  "criminal penalties", "civil penalties", "public records", "registration applicants", 
  "confidential information", "sunset review", "government entity", "exemption from", "security feature", 
  "scanned ballots", "risk-limiting audits", "ballot marking", "board members", 
  "election supervisor", "poll workers", "board duties", "conduct elections", "official ballot", 
  "Dawson County", "Pike County", "public funds", "municipal elections", "appoint members", 
  "oaths privileges", "meetings procedures", "constitutional provision", "Alcoholic beverage", 
  "Class B misdemeanor", "Voting systems", "ballot placement", "certificate of nomination", 
  "Election commission", "public office", "sentencing guidelines", "public trust", "Campaign statements", 
  "calendar month", "state employees", "per diem", "drop-boxes", "election worker", 
  "national guard", "foreign nationals", "recall election", "governing body", "signature page", 
  "second class", "signature stamp", "contested election", "elective office", "civil rights", 
  "business day", "legislative clerk", "campaign expenditure", "campaign committee", 
  "election year", "reporting individual", "mixed media", "civil action", "precinct board", 
  "odd-numbered", "state-issued", "learner's permit", "provisional license", "motor vehicle", 
  "electronic record", "mailing address", "written request", "driver's license", "Indian nation", 
  "school holiday", "mailing labels", "balloting materials", "felony conviction", "online portal", 
  "mailed ballot", "ballot measure", "Election Code", "judicial district", "internet connection", 
  "real-time", "one-half", "even-numbered", "commission-manager", "community college", 
  "interim debentures", "federal securities", "mailed notice", "property owners", "public body", 
  "real property", "tax code", "fourth degree", "municipal clerk", "elective franchise", 
  "nursing homes", "sexual violence", "domestic violence", "facsimile ballots", "distance markers", 
  "public safety", "American flag", "alcoholic beverages", "party committee", "legal authority", 
  "committee meeting", "general assembly", "state constitution", "qualified elector", 
  "full term", "imprisonment parole", "capital letters", "term of", "of imprisonment", 
  "by virtue", "emergency declared", "concealed firearm", "concealed handgun", "law enforcement",

  
  # Trigrams
  "statewide voter registration", "clerk and recorder", "county election official", 
  "voter registration system", "criminal justice system", "political party rules", 
  "election petition requirements", "petition to qualify", "voter service polling", 
  "crime prevention through", "executive director shall", "prevention strategies that", 
  "plan to prevent", "openly carry firearm", "polling location buffer", "one hundred feet", 
  "buffer zone firearms", "voting location safety", "central count facility", 
  "public property buffer", "firearm safety zone", "facilitate the trading", 
  "offense set forth", "trading of votes", "vote trading ban", "committee on *", 
  "city of *", "secretary of state", "board of commissioners", "term of imprisonment", 
  "rights of citizenship", "imprisonment parole capital", "election board members", 
  "ballot affidavit envelope", "early voting locations", "emergency voting centers", 
  "signature verification procedures", "primary election ballot", "county election board", 
  "voting instructions described", "optical scan ballots", "electronic voting system", 
  "voting mark circle", "ballot for paper", "straight party ticket", "local public questions", 
  "precinct election board", "absentee ballots school", "declared disaster emergency", 
  "amend election law", "enrolled voters of", "voting rights act", "protected class vote", 
  "address of legal", "legal residence address", "voter registration application", 
  "supervisor of elections", "residential street addresses", "valid residential addresses", 
  "failure to include distinguishing", "vote-by-mail absentee", "election day ballot", 
  "mailing envelope address", "voter's certificate signature", "marked absentee ballot", 
  "canvassing of ballots", "request for ballot", "voting history report", 
  "write-in candidate residency", "candidate residency requirements", 
  "generative artificial intelligence", "political nature contains", 
  "artificial intelligence use", "public records exemption", "voter registration applicants", 
  "declinations to register", "removing the scheduled", "visible watermark security", 
  "scanned paper ballots", "minimum resolution requirements", "risk-limiting audits", 
  "ballots using optical", "optical character recognition", "board of elections", 
  "conduct of primaries", "duties and responsibilities", "powers and duties", 
  "primaries and elections", "meetings of board", "members of board", 
  "joint board of elections", "appointment of members", "municipal election superintendents", 
  "compensation of members", "special election", "ballot box", "Election day", 
  "risk-limiting audit", "emergency is declared", "secretary of state", 
  "house of representatives", "county road commissioners", "criminal procedure sentencing", 
  "qualified voter file", "campaign finance act", "department of motor vehicles", 
  "rules and regulations", "clerk of the legislature", "legislative caucus committee", 
  "materially deceptive media", "local election fund", "paper registration form", 
  "broadband internet connection", "single-member districts", "notice by mail", 
  "property tax code", "long-term care", "place of worship", "early voting clerk", 
  "voter in the", "days before the", "arguments supporting or", "early ballots stating", 
  "pamphlets shall not", "cast their electoral", "highest number of", 
  "statewide canvass containing", "voter registration form", "proof of citizenship", 
  "national voter registration", "election assistance commission", 
  "federal voter registration", "submit to the", "early voting ballot", 
  "political party affiliation", "early ballot prepared", "early ballot return", 
  "official early ballot", "affidavit of registration", "public official address", 
  "peace officer address", "county recorder records", "court order prohibiting", 
  "county assessor records", "law enforcement officer", "identifying information affidavit", 
  "place of worship"
)



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

# Check out the DFM to see what are the high frequency words -- these are likely the most important words in the analysis 

feature_freq <- topfeatures(dfm_combined, n = nfeat(dfm_combined))

# Print the list of features sorted by frequency
feature_freq

# it would be useful to go through this list of tokens and decide what should not be used.
# for example i think months like stem "novem" should not be included

#save_path <- "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\tony_data_files\\dfm_combined.rds"

# Save the dfm_combined object as an RDS file
# Define the file path where the DFM will be saved
save_path <- "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\Data\\State Policies\\tony_data_files\\dfm_all_8_24_24.rds"

# Save the dfm_combined object as an RDS file
#saveRDS(dfm_combined, file = save_path)





