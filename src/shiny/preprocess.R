# import libraries
library(tm)
library(RWeka)

# get the data 
if(!file.exists("data")){ dir.create("data") }

if(!file.exists("data/Coursera-SwiftKey.zip")){
  url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
  download.file(url, destfile = "data/Coursera-SwiftKey.zip", mode="wb")
}

if(!file.exists("data/final")){ 
  unzip("data/Coursera-SwiftKey.zip", exdir="data")
}




# define functions
(toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x)))
(have <- content_transformer(function(x, pattern) gsub(pattern, " have", x)))
(haveNot <- content_transformer(function(x, pattern) gsub(pattern, "have not", x)))
(hasNot <- content_transformer(function(x, pattern) gsub(pattern, "has not", x)))
(hadNot <- content_transformer(function(x, pattern) gsub(pattern, "had not", x)))
(are <- content_transformer(function(x, pattern) gsub(pattern, " are", x)))
(goingTo <- content_transformer(function(x, pattern) gsub(pattern, "going to", x)))
(wasNot <- content_transformer(function(x, pattern) gsub(pattern, "was not", x)))
(wereNot <- content_transformer(function(x, pattern) gsub(pattern, "were not", x)))
(isNot <-  content_transformer(function(x, pattern) gsub(pattern, "is not", x)))
(areNot <- content_transformer(function(x, pattern) gsub(pattern, "are not", x)))
(wantTo <- content_transformer(function(x, pattern) gsub(pattern, "want to", x)))
(willNot <- content_transformer(function(x, pattern) gsub(pattern, "will not", x)))
(didNot <- content_transformer(function(x, pattern) gsub(pattern, "did not", x)))
(doesNot <- content_transformer(function(x, pattern) gsub(pattern, "does not", x)))
(doNot <- content_transformer(function(x, pattern) gsub(pattern, "do not", x)))
(canNot <- content_transformer(function(x, pattern) gsub(pattern, "can not", x)))

# clean data set
corpus <- VCorpus(DirSource(directory = "./data/final/en_US", encoding="UTF-8", mode="binary"),
                  readerControl = list( language = "en_US", load = TRUE ))

corpus <- tm_map(corpus, content_transformer(stringi::stri_trans_tolower))
corpus <- tm_map(corpus, have, "'ve")
corpus <- tm_map(corpus, hasNot, "hasn't")
corpus <- tm_map(corpus, haveNot, "haven't")
corpus <- tm_map(corpus, hadNot, "hadn't")
corpus <- tm_map(corpus, are, "[^ a-zA-Z]+'re")
corpus <- tm_map(corpus, goingTo, "gonna")
corpus <- tm_map(corpus, wasNot, "wasn't")
corpus <- tm_map(corpus, wereNot, "weren't")
corpus <- tm_map(corpus, isNot, "isn't")
corpus <- tm_map(corpus, areNot, "aren't")
corpus <- tm_map(corpus, wantTo, "wanna")
corpus <- tm_map(corpus, willNot, "won't")
corpus <- tm_map(corpus, didNot, "didn't")
corpus <- tm_map(corpus, doesNot, "doesn't")
corpus <- tm_map(corpus, doNot, "don't")
corpus <- tm_map(corpus, canNot, "can't")
corpus <- tm_map(corpus, canNot, "cannot")
corpus <- tm_map(corpus, canNot, "cant")
corpus <- tm_map(corpus, toSpace, "'s")
corpus <- tm_map(corpus, toSpace, "`s")
corpus <- tm_map(corpus, toSpace, "´s")
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, toSpace, " [#<>*]+ ")
corpus <- tm_map(corpus, toSpace, " [\"]+ ")
corpus <- tm_map(corpus, toSpace, " [-]+ ")

corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)

corpusWithStopWords <- corpus
corpus <- tm_map(corpus, removeWords, stopwords("en"))

corpusWithStopWords  <- tm_map(corpusWithStopWords, PlainTextDocument)
corpus <- tm_map(corpus, PlainTextDocument)

# saving both data sets 
save(corpusWithStopWords, file ="src/shiny/data/corpusWithStopWords.RData")
save(corpus, file ="src/shiny/data/corpus.RData")