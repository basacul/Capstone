# shitty code here
# from generateModel.R as it takes 24 hours for only ngram2 already!!!!
#builds from the ngram data a data.frame with word and frequency
buildPrimitiveDataFrame <- function(ngram, characterVector){
  build <- data.table("word" = character(0), "frequency" = integer(0))
  
  textLength <- length(ngram)
  
  for(i in 1:textLength){
    lengthEntry <- length(ngram[[i]])
    vectorE <- ngram[[i]]
    
    if(length(vectorE) == 0){
      next
    }
    
    for(j in 1:lengthEntry){
      value <- characterVector[vectorE[j]]
      # print(value)
      # print(is.na(value))
      # print(c(i,j))
      if(is.null(value) || is.na(value) || length(value) == 0){
        next
      }
      if(value %in% build$word){
        # print("good")
        increment <- build[build$word == value, 2]
        # print("increment")
        build[build$word == value, 2] = 1 + increment
        # print("bad")
        
      }else{
        # print("done")
        build <- rbind(build, data.frame("word" = value,  "frequency" =1) )
        # print(build)
      }
    }
    
    print(c("round ", i))
  }
  build
}

ngram2Model <- buildPrimitiveDataFrame(ngram2, ngram2Character)