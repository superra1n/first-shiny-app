#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(gdata)
library(ggplot2)

fileURL <- "https://ucr.fbi.gov/crime-in-the-u.s/2013/crime-in-the-u.s.-2013/tables/1tabledatadecoverviewpdf/table_1_crime_in_the_united_states_by_volume_and_rate_per_100000_inhabitants_1994-2013.xls/output.xls"
destfile = "./fbiCrime.xls"

if(!file.exists(destfile)) {
  download.file(fileURL, destfile, method = "curl")
  load("./fbiCrime.xls")
}

## Read data
crimeData <- read.xls("./fbiCrime.xls", skip = 3, header = TRUE)

## Clean up data
crimeData <- crimeData[1:20,1:20]
crimeData[] <- lapply(crimeData, function(x) as.numeric(gsub(",","",as.character(x))))
crimeData[8,1] <- 2001
crimeData[19,1] <- 2012

slopeData1 <- crimeData[1:7,]
slopeData2 <- crimeData[7:nrow(crimeData),]

shinyServer(function(input, output) {
  
  data <- reactive({
    if ( "Violent..crime..rate." %in% input$variable) return("Violent crime rate")
    if ( "Murder.and..nonnegligent..manslaughter..rate." %in% input$variable) return("Murder rate")
    if ( "Rape..legacy.definition.2.rate" %in% input$variable) return("Rape rate")
    if ( "Aggravated..assault.rate." %in% input$variable) return("Assault rate")
  })
  
  data2 <- reactive({
    if ( "Violent..crime..rate." %in% input$variable) return("Violent..crime..rate.")
    if ( "Murder.and..nonnegligent..manslaughter..rate." %in% input$variable) return("Murder.and..nonnegligent..manslaughter..rate.")
    if ( "Rape..legacy.definition.2.rate" %in% input$variable) return("Rape..legacy.definition.2.rate")
    if ( "Aggravated..assault.rate." %in% input$variable) return("Aggravated..assault.rate.")
  })
  
  output$distPlot <- renderPlot({
    fit1 <- lm(as.formula(paste(data2()," ~ Year")), data = slopeData1)
    fit2 <- lm(as.formula(paste(data2()," ~ Year")), data = slopeData2)
    g <- ggplot(data = crimeData, aes(x= Year, y = get(input$variable)))
    g <- g + geom_line(size = 1.5)
    g <- g + geom_vline(xintercept = 2000, color = "green")
    g <- g + xlab("Year (1994 - 2013)")
    g <- g + ylab(data())
    g <- g + ggtitle(paste(data(), "vs Year in US"))
    if (input$box1) {
      g <- g + geom_abline(slope = fit1$coefficients[2], intercept = fit1$coefficients[1], color = "red")
    }
    if (input$box2) {
      g <- g + geom_abline(slope = fit2$coefficients[2], intercept = fit2$coefficients[1], color = "blue")
    }
    g <- g + theme_minimal()
    g 
  })
  
  output$slopeValue1 <- renderText({
    fit1 <- lm(as.formula(paste(data2()," ~ Year")), data = slopeData1)
    fit1$coefficients[2]
  })

  output$slopeValue2 <- renderText({
    fit2 <- lm(as.formula(paste(data2()," ~ Year")), data = slopeData2)
    fit2$coefficients[2]
  })
  
})
