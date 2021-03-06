# prediction model for capstone project
# solution from paper : 
#   BRANTS, Thorsten, et al. Large language models in machine translation. 
#   In: Proceedings of the 2007 Joint Conference on Empirical Methods in Natural 
#   Language Processing and Computational Natural Language Learning (EMNLP-CoNLL). 2007.

#model consist now of uni, bi and trigram with 0.1 of total data set
unigram <- readRDS( file="unigramModel.RData")
bigram <- readRDS( file="bigramModel.RData")
trigram <- readRDS( file="trigramModel.RData")


# instead of number of words in training data OR number of observed unigrams
# simply taking the number of rows of the model set for the stupid backoff model
n <- sum(nrow(unigram), nrow(bigram), nrow(trigram)) 
alpha <- 0.4

swap <<- FALSE # needed to swap between stop and non stop word

# applying stupid backoff model
predictWord <- function(input){
  
  # predction to be returned as a result initialized with empty string
  predictedWord <- ""
  
  # if input is "empty" return either I or and
  if(is.null(input) || input == "" || input == " ")
  {
    if(swap){
      predictedWord <- "and"
      swap <<- FALSE
    }else{
      predictedWord <- "i"
      swap <<- TRUE
    }
    
    return(predictedWord)
  }
  
  #trim leading and trailing whitespace
  input <-  gsub("^\\s+|\\s+$", "", input) 
  
  # assume that between each word only ONE WHITESPACE and count number of words
  numberOfWords <- sapply(strsplit(input, " "), length) 
  
  # if the number of words is above 2, take last two words
  if(numberOfWords > 2){
    input <- tail(strsplit(input ,split=" ")[[1]],2)
    input <- paste(input[1], input[2], sep = " ")
    numberOfWords = 2
  }
  
  # this subset will hold all matching bases in the models and will 
  subset <- data.frame("prediction" = character(0), "score" = double(0))
  # be used to calculated the score
  score <- 0
  
  if(numberOfWords == 1)
  {
    # simple correction not handled by the model
    if(input == "i")
    {
      if(swap)
      {
        predictedWord = "have"
        swap = FALSE
      }
      else
      {
        predictedWord = "am"
        swap = TRUE
      }
    }
    else
    {
      if(input %in% bigram$base)
      {
        set <-bigram[bigram$base == input,]
        
        if(nrow(set) > 2)
        {
          set <- set[1:3,]
        }
        
        rows <- nrow(set)
        
        for(i in 1:rows)
        {
          score <- set[i, "frequency"]
          
          prediction <- as.character(set[i, "prediction"])
     
          if(prediction %in% unigram$prediction)
          {
            denominator <- unigram[unigram$prediction == prediction, "frequency"]
            score <- score/denominator
          }
          else
          {
            score <- score/n
          }
          
          subset <- rbind(subset, data.frame("prediction" = prediction, "score" = score))
        }
      }
      if(nrow(subset) == 0){
        score <- alpha*alpha*unigram[1, "frequency"]
        subset <- rbind(subset, data.frame("prediction" = unigram[1,2], "score" = score))
      }
      subset <- subset[order(-subset$score),]
      predictedWord = as.character(subset[1,1])
      if(predictedWord == "the" && input == "the"){
        predictedWord = as.character(unigram[sample(1:2118,1, replace=TRUE), "prediction"])
      }
    }
    # and finally as well one without base
   
    return(predictedWord)
  }
  else if(numberOfWords == 2)
  {
    print(input)
    if(input %in% trigram$base)
    {
      print("in trigram")
      set <- trigram[trigram$base == input,]
      print(dim(set))
      if(nrow(set) > 2){
        set <- set[1:3,]
      }
      
      rows <- nrow(set)
      
      for(i in 1:rows)
      {
        print("for loop")
        score <- set[i, "frequency"]
        
        prediction <- as.character(set[i, "prediction"])
        base <-  tail(strsplit(input ,split=" ")[[1]],1)
        print(c(prediction, " ", base))
        if(length(bigram[bigram$base == base & bigram$prediction== prediction,"frequency"]) != 0)
        {
          score <- bigram[bigram$base == base & bigram$prediction== prediction,"frequency"]
          print(score)
          # take subset of bigram and check as well if base equals the tail of input!!!!
          if(prediction %in% unigram){
            score <- score/unigram[unigram$prediction == prediction, "frequency"]
          }else{
            score <- score/20 # I forgot that I cut out unigrams that were rare
          }
          print(c("score : " , score))
        }
        else
        {
          print("else")
          score <- score/n
        }
        print(score)
        print(prediction)
        subset <- rbind(subset, data.frame("prediction" = prediction, "score"=score))
      }
    }
    else
    {
      input <- tail(strsplit(input ,split=" ")[[1]],1)
     
      if(input %in% bigram$base)
      {
        set <-bigram[bigram$base == input,]
        
        if(nrow(set) > 2){
          set <- set[1:3,]
        }
        
        rows <- nrow(set)
        
        for(i in 1:rows)
        {
          score <- set[i, "frequency"]
          
          prediction <- as.character(set[i, "prediction"])

          if(prediction %in% unigram$prediction)
          {
            denominator <- unigram[unigram$prediction == prediction, "frequency"]
            score <- score/denominator
          }
          else
          {
            score <- score/n
          }
          
          subset <- rbind(subset, data.frame("prediction" = prediction, "score" = alpha*score))
        }
      }
    }
   
    if(nrow(subset) == 0){
      score <- alpha*alpha*unigram[1, "frequency"]
      subset <- rbind(subset, data.frame("prediction" = unigram[1,2], "score" = score))
    }
    subset <- subset[order(-subset$score),]
    predictedWord = as.character(subset[1,1])
    
    if(predictedWord == "the"){
      #something random
      predictedWord <- as.character(unigram[sample(1:2118,1, replace=TRUE), "prediction"])
    }
    
  
    return(predictedWord)
  }
}
