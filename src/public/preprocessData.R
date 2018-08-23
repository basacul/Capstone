# THIS SCRIPT PERFORMS THE FOLLOWING STEPS
# 1. Load data from text files  DONE
# 2. Clean data DONE
# 3. Generate corpus DONE
# 4. Clean / transform the corpus DONE
# 5. Generate n-grams & write to output files DONE
# The script generateModel.R will continue with the next steps

## necessary libraries
library(tm) # for reading and cleaning the data 
library(RWeka) # for NGramTokenizer: 
library(slam) # for rollup: Rollup (aggregate) sparse arrays along arbitrary dimensions.

# 1. Get the data ###################################################################
if(!file.exists("data")){ dir.create("data") }

if(!file.exists("data/Coursera-SwiftKey.zip")){
  url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
  download.file(url, destfile = "data/Coursera-SwiftKey.zip", mode="wb")
}

if(!file.exists("data/final")){ 
  unzip("data/Coursera-SwiftKey.zip", exdir="data")
}

# 2. Read the data ##################################################################

con <- file("data/final/en_US/en_US.blogs.txt","r")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# news cannot be completely read in Windows 10 , 
# therefore "rb" instead of "r" for read in binary mode
con <- file("data/final/en_US/en_US.news.txt","rb")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("data/final/en_US/en_US.twitter.txt","r")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

rm("con")


# 3. Clean a sample of the data ###################################################
# in order to be reproducible by others
set.seed(33)

sampleFactor <- 0.1
# previous milestone with 0.0005 increased by a factor 200
data.sample <- c(sample(blogs, length(blogs) * sampleFactor),
                 sample(news, length(news) * sampleFactor),
                 sample(twitter, length(twitter) * sampleFactor))

# free up memory space
rm("blogs", "news", "twitter")

# define functions
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
have <- content_transformer(function(x, pattern) gsub(pattern, " have", x))
haveNot <- content_transformer(function(x, pattern) gsub(pattern, "have not", x))
hasNot <- content_transformer(function(x, pattern) gsub(pattern, "has not", x))
hadNot <- content_transformer(function(x, pattern) gsub(pattern, "had not", x))
am <- content_transformer(function(x, pattern) gsub(pattern, " am", x))
im <- content_transformer(function(x, pattern) gsub(pattern, "i am", x))
are <- content_transformer(function(x, pattern) gsub(pattern, " are", x))
will <- content_transformer(function(x, pattern) gsub(pattern, " will", x))
goingTo <- content_transformer(function(x, pattern) gsub(pattern, "going to", x))
wasNot <- content_transformer(function(x, pattern) gsub(pattern, "was not", x))
wereNot <- content_transformer(function(x, pattern) gsub(pattern, "were not", x))
isNot <-  content_transformer(function(x, pattern) gsub(pattern, "is not", x))
areNot <- content_transformer(function(x, pattern) gsub(pattern, "are not", x))
wantTo <- content_transformer(function(x, pattern) gsub(pattern, "want to", x))
willNot <- content_transformer(function(x, pattern) gsub(pattern, "will not", x))
didNot <- content_transformer(function(x, pattern) gsub(pattern, "did not", x))
doesNot <- content_transformer(function(x, pattern) gsub(pattern, "does not", x))
doNot <- content_transformer(function(x, pattern) gsub(pattern, "do not", x))
canNot <- content_transformer(function(x, pattern) gsub(pattern, "can not", x))
couldNot <- content_transformer(function(x, pattern) gsub(pattern, "could not", x))
wouldLike <- content_transformer(function(x, pattern) gsub(pattern, " would like", x))
had <- content_transformer(function(x, pattern) gsub(pattern, " had", x))

# Create corpus and clean the data
corpus <- VCorpus(VectorSource(data.sample))
#tolower issued so many problems that I switched to the stringi tolower function
# use this sign ’ for all these compound statements
# still need to clean this
# unique(unigramModel$base)
# [1]         don’    i’      didn’   can’    doesn’  “       wasn’   isn’    won’    couldn’
# Levels:  don’ i’ didn’ can’ doesn’ “ wasn’ isn’ won’ couldn’

corpus <- tm_map(corpus, content_transformer(stringi::stri_trans_tolower))
corpus <- tm_map(corpus, wouldLike, "’d like")
corpus <- tm_map(corpus, wouldLike, "'d like")
corpus <- tm_map(corpus, had, "’d")
corpus <- tm_map(corpus, had, "'d")
corpus <- tm_map(corpus, have, "'ve")
corpus <- tm_map(corpus, have, "’ve")
corpus <- tm_map(corpus, hasNot, "hasn't")
corpus <- tm_map(corpus, haveNot, "haven't")
corpus <- tm_map(corpus, hadNot, "hadn't")
corpus <- tm_map(corpus, are, "[^ a-zA-Z]+'re")
corpus <- tm_map(corpus, are, "’re")
corpus <- tm_map(corpus, am, "’m")
corpus <- tm_map(corpus, am, "'m")
corpus <- tm_map(corpus, im, "\s*im ") #in order not to mess up with "time", etc
corpus <- tm_map(corpus, goingTo, "gonna")
corpus <- tm_map(corpus, will, "’ll")
corpus <- tm_map(corpus, will, "'ll")
corpus <- tm_map(corpus, wasNot, "wasn't")
corpus <- tm_map(corpus, wereNot, "weren't")
corpus <- tm_map(corpus, isNot, "isn't")
corpus <- tm_map(corpus, areNot, "aren't")
corpus <- tm_map(corpus, wantTo, "wanna")
corpus <- tm_map(corpus, willNot, "won't")
corpus <- tm_map(corpus, willNot, "won’t")
corpus <- tm_map(corpus, didNot, "didn't")
corpus <- tm_map(corpus, didNot, "didn’t")
corpus <- tm_map(corpus, doesNot, "doesn't")
corpus <- tm_map(corpus, doNot, "don't")
corpus <- tm_map(corpus, canNot, "can't")
corpus <- tm_map(corpus, canNot, "cannot")
corpus <- tm_map(corpus, canNot, "cant")
corpus <- tm_map(corpus, toSpace, "'s")
corpus <- tm_map(corpus, toSpace, "’s")
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, toSpace, " [-]+ ")
corpus <- tm_map(corpus, toSpace, " [\"]+ ")
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)
corpusWithoutStopWords <- tm_map(corpus, removeWords, stopwords("en"))

saveRDS(corpus, file="src/shiny/data/corpus.RData" )
saveRDS(corpusWithoutStopWords, file="src/shiny/data/corpusWithoutStopWords.RData" )
# free up some memory space
rm("are", "areNot", "canNot", "didNot", "doesNot", "doNot", "goingTo", "hadNot", "hasNot", "have", "haveNot",
   "isNot", "toSpace", "wantTo", "wasNot", "wereNot", "willNot", "am", "couldNot", "had", "im", "wouldLike", "will")


# 5. Create ngrams and save them for shiny application ######################################

# Prepare n-gram frequencies
getFrequency <- function(tdm) {
  freq <- sort(rowSums(as.matrix(rollup(tdm, 2, FUN = sum)), na.rm = T), decreasing = TRUE)
  return(data.frame(word = names(freq), freq = freq))
}

(bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2)))
(trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3)))
(quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4)))
(pentagram <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5)))
(hexagram <- function(x) NGramTokenizer(x, Weka_control(min = 6, max = 6)))

# Get frequencies of most common n-grams in data sample and store them
rdata <- getFrequency(removeSparseTerms(TermDocumentMatrix(corpusWithoutStopWords), 0.999))
saveRDS(rdata, file="src/shiny/data/unigramWithoutStopWords.RData")
rdata <- getFrequency(removeSparseTerms(TermDocumentMatrix(corpus), 0.999))
saveRDS(rdata, file="src/shiny/data/unigram.RData")
rdata <- getFrequency(TermDocumentMatrix(corpusWithoutStopWords, control = list(tokenize = bigram, bounds = list(global = c(5, Inf)))))
saveRDS(rdata, file="src/shiny/data/bigram.RData")
rdata <- getFrequency(TermDocumentMatrix(corpus, control = list(tokenize = trigram, bounds = list(global = c(3, Inf)))))
saveRDS(rdata, file="src/shiny/data/trigram.RData")

#if sampleFactor = 0.01 ok, but otherwise due to constraint RAM it takes too long - I never succeeded doing it
if(sampleFactor <= 0.01){
  rdata <- getFrequency(TermDocumentMatrix(corpus, control = list(tokenize = quadgram, bounds = list(global = c(2, Inf)))))
  saveRDS(rdata, file="src/shiny/data/quadgram.RData")
  rdata <- getFrequency(TermDocumentMatrix(corpus, control = list(tokenize = pentagram, bounds = list(global = c(2, Inf)))))
  saveRDS(rdata, file="src/shiny/data/pentagram.RData")
  rdata <- getFrequency(TermDocumentMatrix(corpus, control = list(tokenize = hexagram, bounds = list(global = c(2, Inf)))))
  saveRDS(rdata, file="src/shiny/data/hexagram.RData")
}

rm("corpus", "corpusWithoutStopWords", "rdata", "getFrequency","unigramWithoutStopWords", "unigram", 
   "bigram", "trigram", "quadgram", "pentagram", "hexagram")

