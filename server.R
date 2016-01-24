library(shiny)

library('tm')
library('RWeka')
library(wordcloud)
library(ggplot2)
library('qdap')
library('stringr')
#options(warn = -1)


load("unigram.RData")
load("Bigram.RData")
load("Trigram.RData")

predictword_flag <- 0
predictword      <- as.character(NULL)

inputcleaner <- function(term_input)
{
  term_input <- gsub("[^a-z\ ]", "", term_input)
  term_input <- removePunctuation(term_input)
  term_input <- removeNumbers(term_input)
  term_input <- tolower(term_input)
#  term_input <- removeWords(words = stopwords('english'), term_input)
  term_input <- stripWhitespace(term_input)
  return(term_input)
}



wordpredictor <- function(term_input)
{

  term_input             <- unlist(strsplit(term_input, split = " "))  
  term_input_length      <- length(term_input)

  
  if (term_input_length >= 2 & !predictword_flag)
  {
    
    keyword <- paste(term_input[(term_input_length-1):term_input_length], collapse = " ")
    returnword <- Trigram[grep(paste("^",keyword, sep = ""), Trigram$Terms), ]
    
    if (length(returnword[,1]) > 1)
    {
      predictword_flag <- 3
      predictword      <- returnword[1,1]
    }
    
  }
  
  if (term_input_length >= 1 & !predictword_flag)
  {
    
    keyword <- paste(term_input[(term_input_length-1):term_input_length], collapse = " ")
    returnword <- Bigram[grep(paste("^",keyword, sep = ""), Bigram$Terms), ]
    
    if (length(returnword[,1]) > 1)
    {
      predictword_flag <- 2
      predictword      <- returnword[1,1]
    }
    
  }
  
  if (!predictword_flag & term_input_length > 0 )
  {
    
    predictword_flag <- 1
    predictword <- unigram[1,1]
    
  }
  
  
  predictTerm <- word(predictword, -1);
  
  if(term_input_length > 0)
  {
     return_df <- data.frame(term = predictTerm, flag = predictword_flag)
  }
  else
  {
    return_df <- data.frame(term = "", flag = "")
    
  }
  
  return(return_df)
}


shinyServer(function(input, output) {
        output$prediction <- renderPrint({
            predictstring <- wordpredictor(input$inputstring);
            })

        output$Firstword <- renderText({
            term_input <- inputcleaner(input$inputstring)
            predictstring <- wordpredictor(term_input)
            as.character(predictstring[1,1])});
        
        output$Secondword <- renderText({
          term_input <- inputcleaner(input$inputstring)
          predictstring <- wordpredictor(term_input)
          if (predictstring[1,2] == 1)
          {
            outputtext <- "Predicted by unigram."
          }
          if (predictstring[1,2] == 2)
          {
            outputtext <- "Predicted by bigram."
          }
          if (predictstring[1,2] == 3)
          {
            outputtext <- "Predicted by trigram."
          }
          #paste("Note: ", msg);
        })
    }
)
