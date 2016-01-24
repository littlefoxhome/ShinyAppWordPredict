library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Word Predictor"),
  
 

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    textInput("inputstring", "Please enter here!", value = ""),
    submitButton("Predict Next Word")
  ),

  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    p("Please type the input word first."),
    p("Then wait the response of the app to predict next word."),
    br(),
 
    
    h4("Output"),
    verbatimTextOutput("Predict word"),
    textOutput("Firstword"),
    textOutput("Secondword")
  )
))

