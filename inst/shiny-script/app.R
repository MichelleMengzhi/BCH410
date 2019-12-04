library(shiny)
library(rgl)

ui <- tagList(
  navbarPage(
    "homolofy modelling template preparation (hmtp)",
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

    ),

    tabPanel("Template selection",
             sidebarPanel(
               helpText("Select template sequences for given target sequence from given sequence database"),

               fileInput("targetSequence", label = h3("Target Sequence")),
               helpText("The aligned file must be in .fasta"),

               fileInput("databaseSequences", label = h3("Database Sequences")),
               helpText("The file should be in .fasta"),

               fileInput("crossReference", label = h3("Cross Reference")),
               helpText("The file should be in .txt"),

               actionButton('goPlot', 'Submit'),

               downloadButton("downloadData", "Download")
             ),
             mainPanel(
               plotOutput('progress', width = "300px", height = "300px")
             )
    )
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

  output$clickCount <- renderText({
    paste("Download ButtonClicks =", input$rnd)
  })

# =================template selection=====================================


  #output$downloadData <- hmtp::selectTemplates(input$targetSequence$datapath,
  #                                             input$databaseSequences$datapath,
  #                                             input$crossReference$datapath)

  output$progress <- renderPlot({
    input$goPlot # Re-run when button is clicked

    # Create 0-row data frame which will be used to store data
    dat <- data.frame(x = numeric(0), y = numeric(0))

    withProgress(message = 'File generating', value = 0, {
      # Number of times we'll go through the loop
      n <- 10

      for (i in 1:n) {
        # Each time through the loop, add another row of data. This is
        # a stand-in for a long-running computation.
        dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))

        # Increment the progress bar, and update the detail text.
        incProgress(1/n, detail = paste("Doing part", i))

        # Pause for 0.1 seconds to simulate a long computation.
        Sys.sleep(0.1)
      }
    })

    plot(dat$x, dat$y)
  })



}

shinyApp(ui = ui, server = server)
