# Capstone

## Synopsis
Capstone project for the Data Science Specialization track on coursera. This project analyzes a corpus of text and provides the basis for the text prediction application.

## Getting and Cleaning the Data as well as Exploration
The [milestone report](http://rpubs.com/basacul/milestone) shows how the data was processed and the results so far.

## Prediction Model
For our prediction model we will create a database that includes uni-, bi-, tri- and quadgrams from which the prediction will come from. The underlying method will be based on Katz's back-off model, that allows to predict the next word using the created database. Words that are not in the database will be handled like an exception, where the recommendation will be based on the previous prediction in order not to always recommend the next stop word, but alternating between stop and non stop words in case we are unlucky. 
The application will be a shiny app that will be uploaded this week (before august 11 2018) to [ShinyApps by R](https://www.shinyapps.io) a web hoster for R applications.

When building the prediction model subsampling 30% of each file, the script preprocessData.R took only for cleaning the data constantly between 86% and 91% of my working memory of 8GB on Windows 10, from which 10% were used by other applications. After cleaning the data, it got ugly with 99% of RAM usage why working data needed to be saved on disk and read from it, which delayed the process brutally.
Hence I decided to reduce the subsampling at only 0.01% for each file which took around 10 mins and 30 to 35% of memory. Otherwise I would have been stuck forever and it suffices for me.
There is a [proposal](https://github.com/lgreski/datasciencectacontent/blob/master/markdown/capstone-simplifiedApproach.md) by [Len Gresky](https://github.com/lgreski) how to read the whole data and create till pentagrams for the final model by only using 400MB of working memory space. But, I decided to build a prediction model based on the package "tm" after having read [Text Mining Infrastructure in R](https://www.jstatsoft.org/article/view/v025i05).