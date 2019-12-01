library(shiny)

ui <- fluidPage(
  shinythemes::themeSelector(),
  navbarPage(
    # theme = "cerulean",  # <--- To use a theme, uncomment this
    "shinythemes",
    tabPanel("3D alignment of homology proteins",
             sidebarPanel(
               selectInput('alignedPath', 'Aligned file', names(a3v)),
               textInput('targetName', 'Target name', "general"),
               textInput('templateName', 'Template name', "general")
               )
    )
  )
)

server <- function(input, output){
  output$hist <- renderPlot({
    hist(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)
