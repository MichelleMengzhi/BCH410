library(shiny)
library(rgl)

ui <- tagList(
  navbarPage(
    "homology modeling template preparation (hmtp)",
    tabPanel("3D alignment of homology proteins",
             sidebarPanel(
               helpText("The aligned pdb file can be generated from http://fatcat.burnham.org/fatcat-cgi/cgi/fatcat.pl?-func=pairwise."),

               fileInput("alignedFile", label = h3("Aligned file")),
               helpText("The aligned file must be in .pdb"),

               textInput('targetName', 'Target name'),
               helpText("The target will be red in the visualization."),

               textInput('templateName', 'Template name'),
               helpText("The template will be blue in the visualization."),

               submitButton("3D Alignment generated")
               ),
             mainPanel(
               verbatimTextOutput("text"),
               rglwidgetOutput(outputId = "plot")

             )

    )#,

#    tabPanel("Template selection",
#             mainPanel(
#               helpText("Select template sequences for given target sequence from given sequence database"),

#               fileInput("targetSequence", label = h3("Target Sequence")),
#               helpText("The aligned file must be in .fasta"),

#               fileInput("databaseSequences", label = h3("Database Sequences")),
#               helpText("The file should be in .fasta"),

#               fileInput("crossReference", label = h3("Cross Reference")),
#               helpText("The file should be in .txt"),

#               actionButton("button", label = "Submit"),

#               downloadButton("downloadData", "Download")
#             )
#    )
  )

)

server <- function(input, output){
# ==============3D alignment visualization==========================
  output$plot <- renderRglwidget({
    if (is.null(input$alignedFile))
      return(NULL)

    # Generate by functions
    hmtp::alignment3dVisualization(input$alignedFile$datapath,
                                   input$targetName,
                                   input$templateName)
  })
  output$text <- renderText({
    paste("Red is", input$targetName, "\nBlue is", input$templateName)
  })

# =================template selection=====================================


#  observeEvent(input$button, {
#    if (is.null(input$targetSequence))
#      return(NULL)
#    if (is.null(input$databaseSequences))
#      return(NULL)
#    if (is.null(input$crossReference))
#      return(NULL)


#    hmtp::selectTemplates(input$targetSequence$datapath,
#                          input$databaseSequences$datapath,
#                          input$crossReference$datapath)
#    fs <- c(paste0(getwd(),"/alignmentFiles/", collapse = ""),
#            paste0(getwd(),"/templatePDB/", collapse = ""))
#    zip(zipfile = paste0(tempdir(), "/template.zip"), files = fs)
#    file.remove(fs)
#  })

#  output$downloadData <- downloadHandler(
#    filename = "template.zip",
#    contentType = "application/zip",
#    content = function(file){
#      file.copy(paste0(tempdir(), "/template.zip"), file)
#      file.remove(paste0(tempdir(), "/template.zip"))
#    }
#  )




}

shinyApp(ui = ui, server = server)


#pro <- shiny::Progress$new()
#on.exit(pro$close())
#progress$set(message = "Begin to process files, Please wait...", vlaue = 0)
