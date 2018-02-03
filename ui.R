library(shiny)
data(mtcars)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("US Crime Rate before/after release of CSI, a TV drama serie in US"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("variable", "Choose type of crime:",
                  c("Violent crime" = "Violent..crime..rate.",
                    "Rape" = "Rape..legacy.definition.2.rate",
                    "Murder" = "Murder.and..nonnegligent..manslaughter..rate.",
                    "Aggravated Assault" = "Aggravated..assault.rate.")),
      checkboxInput("box1", "Show/Hide Slope 1", value = TRUE),
      checkboxInput("box2", "Show/Hide Slope 2", value = TRUE),
      helpText('CSI: Crime Scene Investigation, an American procedural forensics crime drama television series. It was on TV between October 6, 2000, to September 27, 2015. US crime data can be found on FBI website: https://goo.gl/F8yf71')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"), 
       h5("Green line indicates the year that CSI started broadcasting on TV"),
       h3("The slope value of data before the show was on air"),
       textOutput("slopeValue1"),
       h3("The slope value of data after the show was on air"),
       textOutput("slopeValue2")
    )
  )
))
