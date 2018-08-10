# Capstone

## Synopsis
Capstone project for the Data Science Specialization track on coursera. This project analyzes a corpus of text and provides the basis for the text prediction application.

## Getting and Cleaning the Data as well as Exploration
The [milestone report](http://rpubs.com/basacul/milestone) shows how the data was processed and the results so far.

## Prediction Model
For our prediction model we will create a database that includes uni-, bi-, tri- and quadgrams from which the prediction will come from. The underlying method will be based on Katz's back-off model, that allows to predict the next word using the created database. Words that are not in the database will be handled like an exception, where the recommendation will be based on the previous prediction in order not to always recommend the next stop word, but alternating between stop and non stop words in case we are unlucky. 
The application will be a shiny app that will be uploaded this week (before august 11 2018) to [ShinyApps by R](https://www.shinyapps.io) a web hoster for R applications.

