# runAoo(displayMode='showcase') highlights execution
# while a shiny app runs
# cat displays output to my console
library(shiny)
source("model.R")
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Word Predictor"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
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
      # Input: Text for providing a caption ----
      # Note: Changes made to the caption in the textInput control
      # are updated in the output area immediately as you type
      p()
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      h3("Input: "),
      textInput(inputId = "ngram",
                label="",
                value = ""),
      h3("Output: "),
      #simply ouputId = "prediction"
      # Output: Histogram ----
      h3(textOutput("prediction")),
      p(strong(textOutput("perdiction"))),
      tags$head(tags$style("#prediction{color: red;
                                 font-size: 20px;}"
                         )
      )
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$prediction <-  renderText(paste("Prediction : \"", predictWord(input$ngram), "\"")) #predictWord(input$ngram)
  
}

shinyApp(ui = ui, server = server)