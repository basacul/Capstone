# THIS SCRIPT PERFORMS THE FOLLOWING STEPS
# 6. Aggregate n-gram files to get frequencies by n-gram DONE
# 7. Break n-grams into "base" and "prediction"  DONE
library(data.table)

# unigramWithoutStopWords <- readRDS(file="src/shiny/data/unigramWithoutStopWords.RData")
# unigram <- readRDS(file="src/shiny/data/unigram.RData")
ngram2 <- readRDS("data/ngram2.RData")
ngram3 <- readRDS("data/ngram3.RData")
ngram4 <- readRDS("data/ngram4.RData")

ngram2Character <- attr(ngram2, "types") 
ngram3Character <- attr(ngram3, "types") 
ngram4Character <- attr(ngram4, "types") 
# build base model out of the given n-grams by splitting them
# do not need frequency anymore
buildDataFrame <- function(dtf){
  rows <- nrow(dtf)
  build <- data.frame(matrix(ncol = 2))
  colnames(build) <- c("base", "prediction")
  for(i in 1:nrow(dtf)){
    value <- as.character(dtf[i,1])
    base <- gsub("\\s*\\w*$", "", value)
    prediction <- tail(strsplit(value ,split=" ")[[1]],1)
    build <- rbind(build, list(base, prediction))
  }
  #first entry is "and" if there is no match
  build[1, 2] <- "and"
  build
}

ngram2Character <-  sort(ngram2Character, decreasing = TRUE)
saveRDS(ngram2Character, "data/ngram2Character.RData")
ngram3Character <- sort(ngram3Character, decreasing = TRUE)
saveRDS(ngram3Character, "data/ngram3Character.RData")
ngram4Character <- sort(ngram4Character, decreasing = TRUE)
saveRDS(ngram4Character, "data/ngram4Character.RData")


