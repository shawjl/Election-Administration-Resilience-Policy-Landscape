# Load required libraries



library(topicmodels)
library(quanteda)
library(tidyverse)

# Load the DFM object
file_path <- "C:/Users/tonym/OneDrive/Desktop/Election Administration Resilience & Policy Landscape/Methods and Data Analysis/r_scripts/r_important/dfm_all_8_24_24.rds"
dfm_combined <- readRDS(file_path)

# Convert DFM to a format compatible with topicmodels
dfm_topic <- convert(dfm_combined, to = "topicmodels")

# Perform LDA topic modeling with 8 topics
set.seed(123)  # Ensure reproducibility
lda_model <- LDA(dfm_topic, k = 8, control = list(seed = 123))

# View the terms most associated with each topic
topic_terms <- terms(lda_model, 10)  # Top 10 terms for each topic
print(topic_terms)

# Assign a dominant topic to each document
document_topics <- posterior(lda_model)$topics
dominant_topic <- apply(document_topics, 1, which.max)

# Add topic classification to documents
doc_topic_df <- data.frame(
  Document = rownames(document_topics),
  Dominant_Topic = dominant_topic,
  Topic_Probabilities = apply(document_topics, 1, max)
)

# Save the document classification results
save_path_doc <- "C:/Users/tonym/OneDrive/Desktop/Election Administration Resilience & Policy Landscape/Methods and Data Analysis/r_scripts/r_important/document_topics_8_24_24.csv"
write.csv(doc_topic_df, file = save_path_doc, row.names = FALSE)

# Output: Display the document-topic assignments
print(doc_topic_df)

# Visualize the proportion of each topic across documents
topic_proportions <- colMeans(document_topics)
barplot(topic_proportions, main = "Proportion of Topics Across Documents", xlab = "Topics", ylab = "Proportion")
