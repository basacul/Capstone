# quiz 1
con <- file("../data/final/en_US/en_US.twitter.txt", "r")
love <- 0
hate <- 0

for(i in 1: 2360148 ){
  entry <- readLines(con, 1)
  if(grepl("love", entry)){ 
    love <- love + 1
  }
  if(grepl("hate", entry)){
    hate <- hate + 1
  }
}

ratio <- love/hate

print(ratio)

close(con)



con <- file("../data/final/en_US/en_US.twitter.txt", "r")
search <- "biostats"
for(i in 1: 2360148 ){
  entry <- readLines(con, 1)
  if(grepl(search, entry)){ 
    print(entry)
  }
}
close(con)

con <- file("../data/final/en_US/en_US.twitter.txt", "r")
search <- "A computer once beat me at chess, but it was no match for me at kickboxing"
numberOfMatches <- 0
for(i in 1: 2360148 ){
  entry <- readLines(con, 1)
  if(grepl(search, entry)){ 
    numberOfMatches <- numberOfMatches + 1
  }
}
print(numberOfMatches)
close(con)

