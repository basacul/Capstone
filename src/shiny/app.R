# runAoo(displayMode='showcase') highlights execution
# while a shiny app runs
# cat displays output to my console
library(shiny)
# needed functions and data sets for prediction model
source("model.R")

ui <- fluidPage(
  titlePanel("Word Predictor"),
  sidebarLayout(
    sidebarPanel(
      h3("How it works"),
      p("You can enter anything in the box labeled with \"Input:\" and the 
        model will predict the next word without having to push any buttons."),
      p("This model was trained using a data set in lower case without any 
        numbers, why it is recommended to input your text in lower case and 
        without numbers, too. Otherwise the predictions given by the model 
        will be at random."),
      p("The model will try to guess the next word in real time without 
        having to push any buttons. I hope, you will enjoy using this 
        application."),
      p("This shiny application represents the Capstone Project for the 
        \"John Hopkins Data Science Specialization Track\" in partnerhip 
        with \"Swiftkey\" at Coursera and was optimized for mobile devices."),
      p(img(src = "img/coursera.png", height= 53, width = 200)),
      br(),
      p(img(src = "img/swiftkey.jpg", height= 41, width = 200)),
      br(),
      p()
    ),
    

    mainPanel(
      h3("Input: "),
      textInput(inputId = "ngram",
                label="",
                value = ""),
      h3("Output: "),
      h3(textOutput("prediction")),
      p(strong(textOutput("perdiction"))),
      tags$head(tags$style("#prediction{color: red;
                                 font-size: 20px;}"
                         )
      )
      
    )
  )
)


server <- function(input, output) {
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$ngram) change
  # 2. Its output type is a character
  output$prediction <-  renderText(paste("Prediction : \"", predictWord(input$ngram), "\"")) 
  
}

shinyApp(ui = ui, server = server)