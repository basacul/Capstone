# THIS SCRIPT PERFORMS THE FOLLOWING STEPS
# 1. Load data from text files  DONE
# 2. Clean data DONE
# 3. Generate corpus DONE
# 4. Clean / transform the corpus DONE
# 5. Generate n-grams & write to output files DONE
# The script generateModel.R will continue with the next steps

## necessary libraries
library(xfun)
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
# vector with all three files
files <- c("data/final/en_US/en_US.blogs.txt",
           "data/final/en_US/en_US.news.txt",
           "data/final/en_US/en_US.twitter.txt")


con <- file(files[1],"r")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# news cannot be completely read in Windows 10 , 
# therefore "rb" instead of "r" for read in binary mode
con <- file(files[2],"rb")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file(files[3],"r")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

rm("con")


# 3. Clean input data iteratively ###################################################

# to lower
blogs <- stringi::stri_trans_tolower(blogs, locale = NULL)
news <- stringi::stri_trans_tolower(news, locale = NULL)
twitter <- stringi::stri_trans_tolower(twitter, locale = NULL)

# write back to appropriate files such that I can work with gsub_files
stringi::stri_write_lines(blogs, files[1], encoding= "UTF-8",
                          sep = ifelse(.Platform$OS.type == "windows", "\r\n", "\n"))
stringi::stri_write_lines(news, files[2], encoding= "UTF-8",
                          sep = ifelse(.Platform$OS.type == "windows", "\r\n", "\n"))
stringi::stri_write_lines(twitter, files[3], encoding= "UTF-8",
                          sep = ifelse(.Platform$OS.type == "windows", "\r\n", "\n"))

# free up memory space
rm("blogs", "news", "twitter")

#when cleaning this way, the news text file is not fully read
# clean files with appropriate regex expressions
gsub_files(files, "’d like ", " would like ",  fixed = TRUE)
gsub_files(files, "'d like ", " would like ",  fixed = TRUE)
gsub_files(files, "’d ", " had ",  fixed = TRUE)
gsub_files(files, "'d ", " had ",  fixed = TRUE)
gsub_files(files, "’ve ", " have ",  fixed = TRUE)
gsub_files(files, "'ve ", " have ",  fixed = TRUE)
gsub_files(files, "haven't ", "have not ",  fixed = TRUE)
gsub_files(files, "hasn't ", "has not ",  fixed = TRUE)
gsub_files(files, "hadn't ", "had not ",  fixed = TRUE)
gsub_files(files, "’d ", " had ",  fixed = TRUE)
gsub_files(files, "’m ", " am ",  fixed = TRUE)
gsub_files(files, "'m ", " am ",  fixed = TRUE)
gsub_files(files, "[[:space:]]*im ", "i am ",  fixed = TRUE) 
gsub_files(files, "’ll ", " will ",  fixed = TRUE)
gsub_files(files, "'ll ", " will ",  fixed = TRUE)
gsub_files(files, "’re ", " are ",  fixed = TRUE)
gsub_files(files, "'re ", " are ",  fixed = TRUE)
gsub_files(files, "wasn’t ", "was not ",  fixed = TRUE)
gsub_files(files, "wasn't ", "was not ",  fixed = TRUE)
gsub_files(files, "weren’t ", "were not ",  fixed = TRUE)
gsub_files(files, "weren't ", "were not ",  fixed = TRUE)
gsub_files(files, "isn’t ", "is not ",  fixed = TRUE)
gsub_files(files, "isn't ", "is not ",  fixed = TRUE)
gsub_files(files, "aren’t ", "are not ",  fixed = TRUE)
gsub_files(files, "aren't ", "are not ",  fixed = TRUE)
gsub_files(files, "won’t ", "will not ",  fixed = TRUE)
gsub_files(files, "wonn't ", "will not ",  fixed = TRUE)
gsub_files(files, "don’t ", "do not ",  fixed = TRUE)
gsub_files(files, "don't ", "do not ",  fixed = TRUE)
gsub_files(files, "doesn’t ", "does not ",  fixed = TRUE)
gsub_files(files, "doesn't ", "does not ",  fixed = TRUE)
gsub_files(files, "didn’t ", "did not ",  fixed = TRUE)
gsub_files(files, "didn't ", "did not ",  fixed = TRUE)
gsub_files(files, "can’t ", "can not ",  fixed = TRUE)
gsub_files(files, "can't ", "can not ",  fixed = TRUE)
gsub_files(files, "cant ", "can not ",  fixed = TRUE)
gsub_files(files, "cannot ", "can not ",  fixed = TRUE)
gsub_files(files, "couldn’t ", "could not ",  fixed = TRUE)
gsub_files(files, "couldn't ", "could not ",  fixed = TRUE)
gsub_files(files, " gonna ", " going to ",  fixed = TRUE)
gsub_files(files, " wanna ", "want to ",  fixed = TRUE)
gsub_files(files, "’s ", " ",  fixed = TRUE)
gsub_files(files, "'s ", " ",  fixed = TRUE)
gsub_files(files, "(f|ht)tp(s?)://(.*)[.][a-z]+", " ",  fixed = TRUE)
gsub_files(files, "@[^\\s]+", " ",  fixed = TRUE)
gsub_files(files,"(", "",  fixed = TRUE)
gsub_files(files,")", "",  fixed = TRUE)

# somehow it does not work with [0-9], [!,;:] etc. Ergo Regex expressions
# do somehow not follow syntax as expectected ?! 
# Realized in generateNGram.R, that I can do this with quanteda anyway
# gsub_files(files,",", "",  fixed = TRUE) #remove punctuation
# gsub_files(files,".", "",  fixed = TRUE) #remove punctuation
# gsub_files(files,"!", "",  fixed = TRUE) #remove punctuation
# gsub_files(files,"?", "",  fixed = TRUE) #remove punctuation
# gsub_files(files,":", "",  fixed = TRUE) #remove punctuation
# gsub_files(files,";", "",  fixed = TRUE) #remove punctuation
# gsub_files(files, "0" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "1" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "2" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "3" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "4" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "5" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "6" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "7" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "8" , "",  fixed = TRUE) # remove numbers
# gsub_files(files, "9" , "",  fixed = TRUE) # remove numbers

#data is now clean more or less ;-). The rest is done with quanteda

