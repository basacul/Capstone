# THIS SCRIPT PERFORMS THE FOLLOWING STEPS
# 6. Aggregate n-gram files to get frequencies by n-gram DONE
# 7. Break n-grams into "base" and "prediction"  DONE

# build base model out of the given n-grams by splitting them
buildDataFrame <- function(dtf){
  
  build <- data.frame("base" = character(0), "prediction" = character(0), "frequency" = integer(0))
  
  rows <- nrow(dtf)
  for(i in 1:rows){
    value <- as.character(dtf[i,1])
    
    base <- gsub("\\s*\\w*$", "", value)
    
    prediction <- tail(strsplit(value ,split=" ")[[1]],1)
    
    frequency <- as.integer(dtf[i,2])
    
    build <- rbind(build, data.frame("base" = base, "prediction" = prediction, "frequency" = frequency) )
    print(i)
  }
  
  build
}



sampleFactor <- 0.1

# unigramWithoutStopWords <- readRDS(file="src/shiny/data/unigramWithoutStopWords.RData")
unigram <- readRDS(file="src/shiny/data/unigram.RData")
bigram <- readRDS(file="src/shiny/data/bigram.RData")
trigram <- readRDS(file="src/shiny/data/trigram.RData")

unigramModel <- buildDataFrame(unigram)
unigramModel$base <- ""
# takes 40 min
bigramModel <- buildDataFrame(bigram)
# takes 12 hours - why?
trigramModel <- buildDataFrame(trigram)

saveRDS(unigramModel, file="src/shiny/data/unigramModel.RData")
saveRDS(bigramModel, file="src/shiny/data/bigramModel.RData")
saveRDS(trigramModel, file="src/shiny/data/trigramModel.RData")
finalModel <- rbind(unigramModel, bigramModel, trigramModel)

if(sampleFactor <= 0.01){
  quadgram <- readRDS(file="src/shiny/data/quadgram.RData")
  pentagram <- readRDS(file="src/shiny/data/pentagram.RData")
  hexagram <-  readRDS(file="src/shiny/data/hexagram.RData")
  quadgramModel <- buildDataFrame(quadgram)
  pentagramModel <- buildDataFrame(pentagram)
  hexagramModel <- buildDataFrame(hexagram)
  saveRDS(quadgramModel, file="src/shiny/data/quadgramModel.RData")
  saveRDS(pentagramModel, file="src/shiny/data/pentagramModel.RData")
  saveRDS(hexagramModel, file="src/shiny/data/hexagramModel.RData")
  finalModel <- rbind(unigramModel, bigramModel, trigramModel, quadgramModel, pentagramModel, hexagramModel)
  #base are in upper case compared to all other entries and include for unknown inputs
  finalModel <-  rbind(finalModel,  data.frame("base" = "S", "prediction" = "and", "frequency" = 3)) 
  finalModel <-  rbind(finalModel,  data.frame("base" = "I", "prediction" = "i", "frequency" = 2)) 
}



saveRDS(finalModel, file="src/shiny/data/finalModel.RData")

rm("unigram", "unigramWithoutStopWords","bigram", "bigramModel" ,"trigram", "trigramModel", "quadgram","quadgramModel",
   "pentagram", "pentagramModel","hexagram", "hexagramModel", "finalModel", "buildDataFrame" )



