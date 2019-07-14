# Capstone

## Synopsis
Capstone project for the Data Science Specialization track on coursera. This project analyzes a corpus of text and provides the basis for the text prediction application.

## Getting and Cleaning the Data as well as Exploration
The [milestone report](http://rpubs.com/basacul/milestone) shows how the data was processed and the results so far.

## Prediction Model
For our prediction model we will create a database that includes uni-, bi- and trigrams of the given [corpus](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip), though only 10% will be used as it takes a lot of time with a Lenovoe T430s, i7 and 8GB of RAM. The prediction model will be based on the Stupid Backoff Model as stated in the paper [Large language models in machine translation](http://www.aclweb.org/anthology/D07-1090.pdf) by T. Brants, A.C. Popat, P. Xu, F.J. Och and J. Dean. This model allows a simple implementation based of ngrams and how to predict the next word.
The [application]( https://basacul.shinyapps.io/Ngrams/) is available as a shiny app on [ShinyApps by R](https://www.shinyapps.io) a web hoster for R applications.

When building the prediction model subsampling 10% of each file, the script preprocessData.R took only for cleaning the data constantly between 86% and 91% of my working memory, from which 10% were used by other applications, Furthermore the preprocessData.R script generated the uni-, bi- and trigrams which took approximately 3 hours. The next step was the generation of the data model by the script generateDataModel.R. In this step the prediction model was built. This generation process took around 16 hours to complete, though the bottleneck was the function buildDataFrame(dtf), that dramatically slowed down along the process, for which I found no solution. 
There is a [proposal](https://github.com/lgreski/datasciencectacontent/blob/master/markdown/capstone-simplifiedApproach.md) by [Len Gresky](https://github.com/lgreski) how to read the whole [corpus](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) and how to create till pentagrams for the final model by only using 400MB of working memory space and less time. In the subfolder [Private](https://github.com/basacul/Capstone/tree/master/src/private) I tried his proposal and it allowed me to read the whole given data set without any problems nor delays.
Finally, I decided to abandon this direction and went back to build a prediction model based on the package "tm" after having read [Text Mining Infrastructure in R](https://www.jstatsoft.org/article/view/v025i05), as it was recommended by the course's instructors. But for future projects, I would recommend you to use Len Gresky's proposal as it is more efficient and allows you to use tools, which are designed for such tasks.

The [presentation of this application](http://rpubs.com/basacul/Ngrams) explains the actual problem, the approach to this problem and its solution as a pitch.

## The Process
1. preprocessData.R : The data is downloaded, unzipped and cleaned. Then 2gram, 3gram, 4gram, 5gram and 6gram is created and stored as RDS files
2. generateModel.R :  The model is generated based on these ngrams. A data frame is built from all these ngrams split into base and predicion. This model is stored as RDS file
3. predictWord.R :    This reads the rds file and checks if the n-1 words of the entry has a match in the model. If yes, return prediction. If no word was input return "and" or "I" depending on previously unknown word was already predicted or not. If not known to the model, return a random word from the unigram database.
