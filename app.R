library(shiny)
library(shinyBS)
library(circlize)


source("load_file.R") # for loading files
source("plot.R") 
source("generate_dynamic_line.R") 
source("generate_dynamic_passage.R") 
source("generate_dynamic_mut_type.R") 
source("generate_dynamic_mut_category.R") 


# Allow uploading of large files
options(shiny.maxRequestSize=1000*1024^2)

head_popover_content <-paste(
                             "Minimum required information:",
                             "genome: the name of the virus, eg hiv.",
                             "start: the start position of the mutations.",
                             "line: cell line",
                             "passage: the passage number.",
                             "mut_type: classification of mutations, eg snp, insertion, deletion.",
                             "mut_category: further classification of mutations, eg minor, major, fixated.",
                             "y: float from 0 to 1. Used to place the mutations on the y axis of the circos plot.",
                             "If your file does not contain it, it can be generated by eg (in R):",
                             "sample(seq(0, 1, 0.0000001), nrow(your_dataset), replace = FALSE)",
                             "The order of the columns does not matter. There can be additional columns, but they will not do anything.",
                             sep = "<br/>")

# UI definition
ui <- navbarPage("Visualization of viral passaging",
                
                 tabPanel("File upload",
                          helpText("The app is intended for visualization of viral passaging data. As input, it expects a tabular file of annotated variants."),
                          helpText("For questions, you can contact: lygeri.sakellaridi@uni-wuerzburg.de, Ali.Movasati@usz.ch"),
                          helpText("Project github: https://github.com/Lygeri-Sakellaridi/Visualization-of-viral-passaging-data/"),
                          helpText("First, upload your file here:"),
                          fileInput("file", NULL, buttonLabel = "Upload a csv or tsv file.", 
                                    multiple = FALSE,
                                    accept = c(".csv", ".tsv")),
                          numericInput("n", "Rows", value = 8, min = 1, step = 1),
                          helpText("This is what the beginning of your file looks like. Hover over the table for an explanation on the format."),
                          tableOutput("head"),
                          
                          
                          bsPopover("head", "File format explanation", 
                                    head_popover_content, "bottom")
                          
                          ),
                           
                          
                 tabPanel("Mutations across passages",
                          sidebarLayout(
                            sidebarPanel(
                              numericInput("plot_start_tab2", "Start of plotted region (can be start of genome, or used for zooming)",
                                           value = 0, min = 0),
                              numericInput("plot_end_tab2", "End of plotted region (can be end of genome, or used for zooming)",
                                           value = 9708),
                              selectizeInput("line_tab2", "Select a line.",
        
                                            choices = character(0),
                                            multiple = FALSE),
                              selectizeInput("passages_tab2", "Select passages to compare (up to five; will appear on the plot from outside to the inside in the order they are entered).",
                                            choices = character(0),
                                            multiple = TRUE,
                                            options = list(maxItems = 5)),
                              selectizeInput("mut_types_tab2", "Select mutation types to visualize.",
                                             choices = character(0),
                                             multiple = TRUE
                                
                              ),
                              selectizeInput("mut_categories_tab2", "Select mutation categories to visualize.",
                                             choices = character(0),
                                             multiple = TRUE)
                                            ),
                            mainPanel(
                              helpText("If nothing is being visualized, select at least one choice in every widget."),
                              plotOutput("chrono")
                            )
                          )
                          
                          ),
                 tabPanel("Mutations across lines",
                          sidebarLayout(
                            sidebarPanel(
                              numericInput("plot_start_tab3", "Start of plotted region (can be start of genome, or used for zooming)",
                                           value = 0, min = 0),
                              numericInput("plot_end_tab3", "End of plotted region (can be end of genome, or used for zooming)",
                                           value = 9708),
                              selectizeInput("lines_tab3", "Select lines to compare (up to five; will appear on the plot from outside to the inside in the order they are entered).", 
                                             choices = character(0),
                                             multiple = TRUE,
                              options = list(maxItems = 5)),
                              selectizeInput("passage_tab3", "Select a passage.",
                                             choices = character(0),
                                             multiple = FALSE),
                              selectizeInput("mut_types_tab3", "Select mutation types to visualize.",
                                             choices = character(0),
                                             multiple = TRUE
                                             
                              ),
                              selectizeInput("mut_categories_tab3", "Select mutation categories to visualize.",
                                             choices = character(0),
                                             multiple = TRUE)
                            ),
                            mainPanel(
                                  helpText("If nothing is being visualized, select at least one choice in every widget."),
                                  plotOutput("interline")
                            
                          )
                          
                 )
                 ),
)


# Server definition
server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    load_file(input$file$name, input$file$datapath)
  })
  output$head <- renderTable({
    head(data(), input$n)
  })
  generate_dynamic_line(data(), "line_tab2")
  generate_dynamic_passage(data(), "passages_tab2")
  generate_dynamic_mut_type(data(), "mut_types_tab2")
  generate_dynamic_mut_category(data(), "mut_categories_tab2")
  output$chrono <- renderPlot({
    plot_chrono(data(), input$plot_start_tab2, input$plot_end_tab2,
                input$line_tab2, input$passages_tab2,
                input$mut_types_tab2, input$mut_categories_tab2)
  },
  height = "auto", width = "auto")
  generate_dynamic_line(data(), "lines_tab3")
  generate_dynamic_passage(data(), "passage_tab3")
  generate_dynamic_mut_type(data(), "mut_types_tab3")
  generate_dynamic_mut_category(data(), "mut_categories_tab3")
  output$interline <- renderPlot({
    plot_interline(data(), input$plot_start_tab3, input$plot_end_tab3,
                input$lines_tab3, input$passage_tab3,
                input$mut_types_tab3, input$mut_categories_tab3)
  },
  height = "auto", width = "auto")
  
}

shinyApp(ui, server)


