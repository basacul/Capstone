# Tasks to accomplish
#
# 1. Build a predictive model based on the previous data modeling steps - 
#    you may combine the models in any way you think is appropriate.
# 2. Evaluate the model for efficiency and accuracy - use timing software 
#    to evaluate the computational complexity of your model. 
#    Evaluate the model accuracy using different metrics like perplexity, 
#    accuracy at the first word, second word, and third word.
#
# Questions to consider
#
# 1. How does the model perform for different choices of the parameters and size of the model?
# 2. How much does the model slow down for the performance you gain?
# 3. Does perplexity correlate with the other measures of accuracy?
# 4. Can you reduce the size of the model (number of parameters) without reducing performance?


# library(shiny)
# create subfolder shiny with ui.R and server.R for shiny application
# then create database for the application with up to 4grams
# write this database sorted into 4 different files each for a Xgram
# adapt ui.R to display entry bar and display of the next prediction
# adapt server.R to handle input and perform next prediction

# The general process is:
#
# 1. Load data from text files  DONE
# 2. Clean data DONE
# 3. Generate corpus DONE
# 4. Clean / transform the corpus DONE
# 5. Generate n-grams & write to output files DONE
# 6. Aggregate n-gram files to get frequencies by n-gram
# 7. Break n-grams into "base" and "prediction" 

