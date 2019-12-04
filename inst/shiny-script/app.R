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

               submitButton("Submit")
               ),
             mainPanel(
               rglwidgetOutput(outputId = "plot"),
               verbatimTextOutput("text")
             )
    )



  )

)

server <- function(input, output){
  output$plot <- renderRglwidget({
    # Generate by functions
    hmtp::alignment3dVisualization(input$alignedFile$datapath,
                                   input$targetName,
                                   input$templateName)
  })
  output$text <- renderText({
    paste("Red is", input$targetName, "\nBlue is", input$templateName)
  })


}

shinyApp(ui = ui, server = server)
