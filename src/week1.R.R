#get and clean the data

getwd()

# 1. Obtain the data - Can your download the data and load/manipulate it in R?

if(!file.exits("../data")){ dir.create("../data") }

if(!file.exists("../data/Coursera-SwiftKey.zip")){
  # source of data 
  url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
  
  download.file(url, destfile = "../data/Coursera-SwiftKey.zip", mode="wb")
  dateWhenDownloaded <- date()
}

if(!file.exists("../data/final")){ 
  unzip("../data/Coursera-SwiftKey.zip", exdir="../data")
}

# create path names for all files
path <- "../data/final"
en <- "/en_US"
de <- "/de_DE"
fi <- "/fi_FI"
ru <- "/ru_RU"
twitter <- ".twitter.txt"
news <- ".news.txt"
blogs <- ".blogs.txt"

path_twitter_EN <- paste(path, en, en, twitter, sep = "")
path_blogs_EN <- paste(path, en, en, blogs, sep = "")
path_news_EN <- paste(path, en, en, news, sep = "")

path_twitter_DE <- paste(path, de, de, twitter, sep = "")
path_blogs_DE <- paste(path, de, de, blogs, sep = "")
path_news_DE <- paste(path, de, de, news, sep = "")

path_twitter_FI <- paste(path, fi, fi, twitter, sep = "")
path_blogs_FI <- paste(path, fi, fi, twitter, sep = "")
path_news_FI <- paste(path, fi, fi, twitter, sep = "")

path_twitter_RU <- paste(path, ru, ru, twitter, sep = "")
path_blogs_RU <- paste(path, ru, ru, blogs, sep = "")
path_news_RU <- paste(path, ru, ru, news, sep = "")



# check for entries in twitter EN 
con <- file(path_twitter_EN, "r")
readLines(con, 1) ## Read the first line of text 
readLines(con, 1) ## Read the next line of text 
readLines(con, 5) ## Read in the next 5 lines of text 
close(con)





# when counting line numbers errors are thrown
# length(readLines(con)) does the job

# subsample the text by using rbinom. create a file where the subsamples are stored


# 1 -> tokenization - identifying appropriate tokens such as words, 
#      punctuation, and numbers. Writing a function that takes a file 
#      as input and returns a tokenized version of it.
# 2 -> profanity filtering - removing profanity and other words you do 
#      not want to predict.

# Qurestions to consider
# 1. What does the data look like?
# 2. Where do the data come from?
# 3. Can you think of any other data sources that might help you in this project?
# 4. What are the common steps in natural language processing?
# 5. What are some common issues in the analysis of text data?
# 6. What is the relationship between NLP and the concepts you have learned in the Specialization?