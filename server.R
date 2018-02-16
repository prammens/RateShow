
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggvis)

function(input, output, session) {

  ## todo: calc 100 random interest rates using lower and upper limit from input
  
  df <- reactive({

    # get inputparameters
    stam <- input$stam
    moin <- input$moin
    intrate <- input$intrate/100/12
    
    # set ticks ands baseline
    MOS    <- c(1:(15*12)) # 15 years, monthly
    MOIN <- seq(from=(moin),to = 15*12*(moin), by = moin) # raw money invested
    MOIN <- MOIN + stam # raw money invested + startamount
    
    # set random int rates
    intrate2 <- runif(length(MOS), min=-5, max=15)/100/12
    
    # setup df
    intdf <- data.frame(MOS=MOS, rate=intrate, rate2=intrate2,
                        stam=stam, incr=moin, AMOATEND=moin, MOIN=MOIN) 
    
    # set initial values
    intdf$AMOATEND[1] <- intdf$stam[1] + intdf$stam[1]*intdf$rate[1] + intdf$incr[1]
    intdf$AMOATEND2[1] <- intdf$stam[1] + intdf$stam[1]*intdf$rate2[1] + intdf$incr[1]
    
    # build up amounts including interest   
    for (i in 1:(dim(intdf)[1]-1)){
      intdf$AMOATEND[i+1] <- intdf$AMOATEND[i]+intdf$AMOATEND[i]*intdf$rate[i+1]+intdf$incr[i+1]
    } 
    for (i in 1:(dim(intdf)[1]-1)){
      intdf$AMOATEND2[i+1] <- intdf$AMOATEND2[i]+intdf$AMOATEND2[i]*intdf$rate2[i+1]+intdf$incr[i+1]
    } 
    
    # calc differences
    intdf$RAWDIFF <- intdf$AMOATEND-intdf$MOIN
    intdf$RAWDIFF2 <- intdf$AMOATEND2-intdf$MOIN
    
    intdf
    
  })
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    
    df %>%
      ggvis(~MOS,~MOIN)  %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
      layer_points(~MOS,~AMOATEND, size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
      layer_points(~MOS,~AMOATEND2, size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
      add_axis("x", title = 'Months') %>%
      add_axis("y", title = 'Value') %>%
      layer_smooths()

  })
  
  vis2 <- reactive({
    
    df %>%
      ggvis(~MOS,~RAWDIFF)  %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
      layer_points(~MOS,~RAWDIFF2, size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5) %>%
      add_axis("x", title = 'Months') %>%
      add_axis("y", title = 'Value') %>%
      layer_smooths()  
    
  })
  
  # tell a name to use in ui.R
  vis %>% bind_shiny("invest")
  vis2 %>% bind_shiny("invdif")

}
