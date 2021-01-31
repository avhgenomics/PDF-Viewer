#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = "reader.css",

    # Application title
    titlePanel("Basic PDF Reader"),

    # Sidebar with PDF options
    sidebarLayout(
        sidebarPanel(
            fileInput(inputId = "pdf_file",label = "pdf",buttonLabel = "Find your PDF"),
            actionButton(inputId = "pdf_load","Load File"),
            numericInput(inputId = "pdf_window_width",label = "PDF width",min = 0,max = 10000,value = 1000,step = 10),
            numericInput(inputId = "pdf_window_height",label = "PDF height",min = 0,max = 10000,value = 800,step = 10),
            sliderInput(inputId = "slider1_height",label = "Proportion of Top covered?",min = 0,max = 100,value = 10,step = 1),
            sliderInput(inputId = "slider2_height",label = "Proportion of Bottom covered?",min = 0,max = 100,value = 10,step = 1)
        ),

        # Show the PDF output
        mainPanel(
            uiOutput("pdf_path")

        )
)
)

# Define server logic required to load pdf
server <- function(input, output) {


    file_location <- eventReactive(input$pdf_load,{
        addResourcePath(prefix = "pdfs",directoryPath = dirname(input$pdf_file$datapath))
        paste0("pdfs/",basename(path = input$pdf_file$datapath))
    })

    output$pdf_path <- renderUI({

        tags$div(
            style = glue::glue(
                "background-color: lightblue;
                height: {input$pdf_window_height}px;
                width: {input$pdf_window_width}px;
                "),
            tags$iframe(
                src=file_location(),
                style="height:100%; width:100%;scrolling=yes; scroll-behavior: smooth;"
                ),
            tags$div(
                style = glue::glue(
                    "height: {input$slider1_height}%;
                     top: 0;
                     width: 100%;
                     pointer-events: none;
                     position: absolute;"),
                tags$div(
                    style = glue::glue(
                        "background: rgba(255,255,255,0.95);
                     height: 90%;
                     top: 0;
                     width: 100%;
                     pointer-events: none;
                     position: absolute;")
                ),
                tags$div(
                    style = glue::glue(
                        "background: linear-gradient(to bottom,rgba(255,255,255,0.95),rgba(255,255,255,0));
                     height: 10%;
                     bottom: 0;
                     width: 100%;
                     pointer-events: none;
                     position: absolute;")
                )
            ),
            tags$div(
                style = glue::glue(
                    "height: {input$slider2_height}%;
                     bottom: 0;
                     width: 100%;
                     pointer-events: none;
                     position: absolute;"),
                tags$div(
                    style = glue::glue(
                        "background: rgba(255,255,255,0.95);
                     height: 90%;
                     bottom: 0;
                     width: 100%;
                     pointer-events: none;
                     position: absolute;")
                ),
                tags$div(
                    style = glue::glue(
                        "background: linear-gradient(to bottom,rgba(255,255,255,0),rgba(255,255,255,0.95));
                     height: 10%;
                     top: 0;
                     width: 100%;
                     pointer-events: none;
                     position: absolute;")
                )
            )
            )
        })


    output$file_loc <- renderPrint(file_location())


}

# Run the application
shinyApp(ui = ui, server = server)
