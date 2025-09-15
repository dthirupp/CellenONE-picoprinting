---
title: "shiny_syncom"
author: "Deepan"
date: "9/10/2025"
output: html_document
---

## Load required libraries. If you don't have them, install with install.packages("package_name"). Might need to restart your R session after installing shiny. 

library(shiny)
library(png)
library(jpeg)
library(stringr)
library(dplyr)
library(reshape)

## defining the user interface

ui <- fluidPage(
  titlePanel("Upload Files Sequentially"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("nfiles", "How many bacteria in your SynCom?", value = 3, min = 1),
      fileInput("target_file", "Upload the target based field file", accept = c("target_file/fld")),
      uiOutput("file_ui"),
      actionButton("nextFile", "Next File"),
      downloadButton("download", "Download Combined Data")
    ),
    
    mainPanel(
      tableOutput("preview")
    )
  )
)

## defining the server space

server <- function(input, output, session) {
  
  # Initialize reactive values for the field file coordinates to update with each organism.
  rv <- reactiveValues(
    file_index = 1,
    df = data.frame(
      row = c(paste(1, rep(1:8), sep = "/"), 
              paste(2, rep(1:8), sep = "/"),
              paste(3, rep(1:8), sep = "/"),
              paste(4, rep(1:8), sep = "/"),
              paste(5, rep(1:8), sep = "/"),
              paste(6, rep(1:8), sep = "/"),
              paste(7, rep(1:8), sep = "/"),
              paste(8, rep(1:8), sep = "/"),
              paste(9, rep(1:8), sep = "/"),
              paste(10, rep(1:8), sep = "/"),
              paste(11, rep(1:8), sep = "/"),
              paste(12, rep(1:8), sep = "/")),
      variable = "",
      value = "",
      stringsAsFactors = FALSE
    )
  )
  

  
  # Step 1: Show current file + well input dynamically
  output$file_ui <- renderUI({
    req(input$nfiles)
    if (rv$file_index <= input$nfiles) {
      tagList(
        fileInput("current_file", paste("Upload TSV", rv$file_index), accept = ".tsv"),
        textInput("well_position", paste("Enter the probe plate well ID for bacteria", rv$file_index, "(e.g., A1, B3, ...)"))
      )
    } else {
      h4("All files uploaded!")
    }
  })
  
  # Step 2: Process when Next File button is pressed
  observeEvent(input$nextFile, {
    req(input$current_file, input$well_position)  # both must exist
    
    # Read TSV
    df <- read.table(input$current_file$datapath, sep = "\t", header = TRUE, row.names = 1) #uploaded files are TSV, with no leading blank columns or rows. 
    
    # Rename the rows and columns to make the coordinates. 
    rownames(df) <- 1:8
    colnames(df) <- 1:12
    
    # Melt into long format
    df$row <- as.character(rownames(df))
    df <- reshape::melt(df, id.vars = "row")
    df$row <- paste(df$variable, df$row, sep = "/")
    df$variable <- ifelse(!is.na(df$value),
                           paste("1", input$well_position, sep = ""),
                           "")
    
    df$value <- ifelse(!is.na(df$value), df$value, "")
    
    # Update rv$df
    rv$df <- rv$df %>%
      full_join(df, by = "row") %>%
      mutate(
        variable = paste(variable.y, ",", variable.x, sep = ""),
        value    = paste(value.y, ",", value.x, sep = ""),
        
        variable = ifelse(variable == ",", "", variable), 
        value = ifelse(value == ",", "", value)
      ) %>%
      select(row, variable, value)
    
    # Advance to next file slot
    if (rv$file_index < input$nfiles) {
      rv$file_index <- rv$file_index + 1
    }
  })
  
  # Step 3: Preview combined data (only 20 rows)
  output$preview <- renderTable({
    head(rv$df, 20)
  })
  
  # Step 4: Download field file after combining file header lines and footer (signature) lines. 
output$download <- downloadHandler(
  filename = "syncom_field_file.fld",
  content = function(file) {
    header_lines <- readLines(input$target_file$datapath, n = 23)
    blank_line <- ""
    signature <- "§18-23-49-70-25-41-27-75-54-34-53-33-41-55-77-64-61-59-21-22-40-36-71-79-57-64-28-55-43-41-25-75-54-78-50-37-64-25-57-45-68-34-50" #standard signature junk line, necessary for the robot. Do not modifiy or remove this. 
    
    # Turn df into a character vector of lines and combine
    df_lines <- apply(rv$df, 1, function(x) paste(x, collapse = "\t"))
    writeLines(
      c(header_lines, df_lines, blank_line, signature),
      file,
      sep = "\n"
    )
  }
)


}


## Run the app (open the app in your default browser if it doesn't automatically do so)

shinyApp(ui, server) 


