library(readr)

# Define the path to the RDS file
file_path <- "C:\\Users\\tonym\\Box\\Election Administration Resilience & Policy Landscape\\Data\\State Policies\\final_rule_text_combined_7_24.rds"

# Load the RDS file
df_combined <- readRDS(file_path)



colnames(df_combined)
df_combined[df_combined$bill_title == "IN H 1265", "final_text"]

\n needs to be removed....numbers.....also "Section"

Begening: everything before "HOUSE ENROLLED ACT No. 1265" (In my opinion Preambles should be taken out manually)

end taken out: \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nSpeaker of the House of Representatives\n\n\n\n2002535246557\nPresident of the Senate\n\n\n\n2002535247065\nPresident Pro Tempore\n\n\n\n2002535248589\nGovernor of the State of Indiana\n\n\n\nDate:Time:"






df_combined[df_combined$bill_title == "IN S 558", "final_text"]

everything before: SENATE ENROLLED ACT No. SENATE ENROLLED ACT No

stop words: Remove sybols and dollar sign...everythng else can remain in

df_combined[df_combined$bill_title == "IN H 1335", "final_text"]
stop" dont need things ib between "." I think like P.L, IC

.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nSpeaker of the House of Representatives\n\n\n\n2002535246557\nPresident of the Senate\n\n\n\n2002535247065\nPresident Pro Tempore\n\n\n\n2002535248589\nGovernor of the State of Indiana\n\n\n\nDate:Time:"


df_combined[df_combined$bill_title == "IN S 570", "final_text"]

df_combined[df_combined$bill_title == "IN S 425", "final_text"]




# NEXT KY


df_combined[df_combined$bill_title == "KY H 622", "final_text"]

weird arrow symbols "🢂".....removing numbers might get you thiunks like 

df_combined[df_combined$bill_title == "KY H 580", "final_text"]
stop words: act, chapter, session "GENERAL ASSEMBLY" "SENATE:
  
  

(begining just starts and end just starts)

df_combined[df_combined$bill_title == "KY S 169", "final_text"]\

just begins: End taken out is is Signed by Governor March 23, 2023.

stopw rodes: take out date 
"on-line" --pretty odd lol i wouldnt worry about it

df_combined[df_combined$bill_title == "KY H 53", "final_text"]

aENERAL ASSEMBLY" "SENATE:

df_combined[df_combined$bill_title == "KY H 302", "final_text"]

taken out: \nSigned by Governor March 23, 2023."



df_combined[df_combined$bill_title == "MI H 4177", "final_text"]

EVERYTHING BEFORE :  ENROLLED HOUSE BILL No. 4177 
everything after: Enacting section 1
removed: \t MCL PA(perjaps any "word" with all caps should be removed)

df_combined[df_combined$bill_title == "MI H 5131", "final_text"]
eveyrthig before: ENROLLED HOUSE BILL No. 5131
everything aFTER: Enacting section 1. 


df_combined[df_combined$bill_title == "MI H 4696", "final_text"]

same 

df_combined[df_combined$bill_title == "MI S 814", "final_text"]



df_combined[df_combined$bill_title == "MI S 212", "final_text"]

\r



df_combined[df_combined$bill_title == "MN S 2", "final_text"]
before: A bill for an act
afte: EFFECTIVE DATE. This section is
\r \n


df_combined[df_combined$bill_title == "MN S 2381", "final_text"]


df_combined[df_combined$bill_title == "MN H 3", "final_text"]

cant awlays do end because soemtyimes effecftive date changes "end will need to e determined manually"

df_combined[df_combined$bill_title == "MN H 4772", "final_text"]


df_combined[df_combined$bill_title == "MN S 1", "final_text"]

remove: Ln  AGIIN LETTS LEFT ALONE AFTER NUMBERS AND LETTER REMOVED, also "paragraph" orf words like that" LAW STATUTE









IN S 558
IN H 1335
IN S 570
IN S 425



df_combined[df_combined$bill_title == "NY A 4257", "final_text"]

df_combined[df_combined$bill_title == "FL H 919", "final_text"]


df_combined$bill_title
