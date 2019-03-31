# server.R
library(ggplot2)
library(ggpmisc)
library(anytime)
library(grid)
library(stringr)
library(RJSONIO)
library(Rbitcoin)
library(plyr)
library(igraph)
library(dplyr)
library(lubridate)

setwd("~/r-studio-workspace/bitcoin/grin")

server <- function(input, output) {
  
  # load data
  load("./data/blocks.RData")
  blocks$edge_bits <- as.factor(blocks$edge_bits)
   
  today <- as.numeric(as.POSIXct(Sys.Date()))*1000
  
  output$dateSelector <- renderUI({
      if(input$radio==1) days=1
      else if(input$radio==2) days=7
      else if(input$radio==3) days=30
      MIN <- min(blocks$height)
      MAX <- max(blocks$height)
      sliderInput(
        "height",
        "Select start and stop height",
        min = MIN,
        max = MAX ,
        value = c(MAX -  days*24*60,  MAX)
      )
  })
   
   output$dateBox <- renderInfoBox({
      infoBox(
         "Blockchain",
         paste0("Current height: ",max(blocks$height)),
         icon = icon("server"),
         color = "green"
      )
   })

   output$speedBox <- renderInfoBox({
      infoBox(
         "Blocks in period",
         nrow(blocks[(blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]), ]),
         icon = icon("server"),
         color = "yellow"
      )
   })

   output$pulseBox <- renderInfoBox({
      infoBox(
         "Difficulty",
         paste0("Total difficulty: ",max(blocks$total_difficulty)),
         icon = icon("server"),
         color = "red"
      )
   })
   
   
   output$a11 <- renderPlot({
      filter <- blocks$edge_bits == 0
      if (1 %in% input$checkGroup)
        filter <- filter | (blocks$edge_bits == 29)
      if (2 %in% input$checkGroup)
        filter <- filter | (blocks$edge_bits == 31)
      if (2 %in% input$checkGroup)
        filter <- filter | (blocks$edge_bits == 32)
     
      filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
      filter <- filter & filter_time
      
      ggplot(data=blocks[filter, ], aes(x=height, y=delta, color=edge_bits, alpha=0.1)) +
         geom_point() +
         labs(title="Grin block delay",
              x ="Height", y = "Delay") +
         theme(axis.text.x = element_text(angle=45, hjust=1)) 
   })
   
   output$a12 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=delta, fill=edge_bits, alpha=0.1)) +
       geom_histogram() +
       labs(title="Grin block delay distribution",
            x ="Delay", y = "Blocks") +
       theme(axis.text.x = element_text(angle=45, hjust=1)) 
   })
   
   output$a21 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=height, y=nonce/10^18, color=edge_bits, alpha=0.1)) +
       geom_point() +
       labs(title="Grin nonce",
            x ="Height", y = "Nonce (*10^18)") +
       theme(axis.text.x = element_text(angle=45, hjust=1)) 
   })
   
   output$a22 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=nonce/10^18, fill=edge_bits, alpha=0.1)) +
       geom_histogram() +
       labs(title="Grin nonce distribution",
            x ="Nonce (*10^18)", y = "#Blocks") +
       theme(axis.text.x = element_text(angle=45, hjust=1)) 
   })
   
   output$a31 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=height, y=secondary_scaling, color=edge_bits, alpha=0.1)) +
       geom_point() +
       labs(title="Grin secondary scaling",
            x ="Height", y = "Secondary scaling") +
       theme(axis.text.x = element_text(angle=45, hjust=1))  
   })
   
   output$a32 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=secondary_scaling, fill=edge_bits, alpha=0.1)) +
       geom_histogram() + 
       labs(title="Grin secondary scaling distribution",
            x ="Secondary scaling", y = "#Blocks") +
       theme(axis.text.x = element_text(angle=45, hjust=1))  
   })
   
   output$a41 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=height, y=total_difficulty, color=edge_bits, alpha=0.1)) +
       geom_point() +
       labs(title="Grin difficulty",
            x ="Height", y = "Difficulty") +
       theme(axis.text.x = element_text(angle=45, hjust=1))  
   })
   
   output$a42 <- renderPlot({
     filter <- blocks$edge_bits == 0
     if (1 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 29)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 31)
     if (2 %in% input$checkGroup)
       filter <- filter | (blocks$edge_bits == 32)
     
     filter_time <- (blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]) 
     filter <- filter & filter_time
     
     ggplot(data=blocks[filter, ], aes(x=timestamp, y=height, color=edge_bits, alpha=0.1)) +
       geom_point() +
       labs(title="Grin height",
            x ="Timestamp", y = "Height") +
       theme(axis.text.x = element_text(angle=45, hjust=1))  
   })
   
   output$data <- renderDataTable(blocks[(blocks$height >= input$height[[1]]) & (blocks$height <= input$height[[2]]), ])
}