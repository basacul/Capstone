library(quanteda)

files <- c("data/final/en_US/en_US.blogs.txt",
           "data/final/en_US/en_US.news.txt",
           "data/final/en_US/en_US.twitter.txt")


con <- file(files[1],"r")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE) # 899288
close(con)

# news cannot be completely read in Windows 10 , 
# therefore "rb" instead of "r" for read in binary mode
con <- file(files[2],"rb")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE) # 77259
close(con)

con <- file(files[3],"r")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE) # 2360148
close(con)

set.seed(33)
#full news and 20% of blogs and twitter
data <- c(sample(blogs, length(blogs)*0.2), 
          news, 
          sample(twitter,length(twitter)*0.2))

saveRDS(data, file="data/partialData.RData")

rm("con", "blogs", "news", "twitter", "files")

# tokenize and build n-grams. solution from 
# https://tutorials.quanteda.io/basic-operations/tokens/tokens/
toks <- tokens(data, remove_numbers = TRUE, remove_punct = TRUE,
               remove_symbols = TRUE, remove_separators = TRUE,
               remove_twitter = TRUE, remove_hyphens = TRUE, 
               remove_url = TRUE)

saveRDS(toks, file="data/partialToks.RData")
rm("data")

# generates 2 till 4-grams as above that it takes too much capactity and time
ngram2 <- tokens_ngrams(toks, n = 2) # Size: 0.46 GB 
saveRDS(ngram2, file="data/ngram2.RData")
rm("ngram2")
ngram3 <- tokens_ngrams(toks, n = 3) # Size: 0.90 GB
saveRDS(ngram3, file="data/ngram3.RData")
rm("ngram3")
ngram4 <- tokens_ngrams(toks, n = 4) # Size: 1.2 GB
saveRDS(ngram4, file="data/ngram4.RData")
rm("ngram4")


#each ngram2 has 729145 entries as in toks
# each of these entries has a different number of entries stored in ngramX[1:729145]
#  these reference to the entry in attr(ngramX, "type") consisting of the ngram
# now write a function that creates a database with base and prediction. Good Luck.
