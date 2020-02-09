##

library(shiny)  #install.packages("shiny")
library(shinydashboard)  #install.packages("shinydashboard")

library(dplyr)     #install.packages("dplyr")
library(ggplot2)   #install.packages("ggplot2")


cancer1 <- read.csv("five_year_cancer_survival_rates_in_usa.csv")



ui <- dashboardPage(skin = "green",
        
        dashboardHeader(title = "USA Five Year Cancer Survival Rates", titleWidth = 450),
        dashboardSidebar(
                sidebarMenu( 
                        menuItem(text = "Dashboard", tabName = "dash", icon = icon("dashboard")),
                        menuItem(text = "Source Code", icon = icon("file-code-o"), href = "https://github.com/manufonn/") 
                                                       ),
              
                
                selectInput(inputId = "somename", label = "Other Cancers:", choices = c("All cancers", "Bladder", "Brain and nervous system", "Breast", "Cervix uteri", "Colon and rectum", "Esophagus", "Leukemia", "Liver", "Lung and bronchus", "Myeloma", "Ovary", "Prostate", "Skin", "Stomach", "Thyroid"), selected = "Bladder")
                          
                         ), 
        

        
        dashboardBody(
                tabItems(
                        tabItem(tabName = "dash", h1("Overview of 5 Year Survival Rates for different types of cancers in the US 1963-2013."))
                        
                                

                ),
          fluidRow( 
                  
                
         box(title = "Survival Rates", status = "primary", background = "teal", solidHeader = TRUE, 
             plotOutput(outputId =  "gplot")   )
          ),
         
         fluidRow(
                 
                 box(title = "How to Use:", status = "warning", solidHeader = TRUE,
                     textOutput(outputId = "docu") )
         )
         
        )
             
        )

server <- function(input, output) {
        
     output$gplot   <- renderPlot({
             
             
             
             cancertype <- cancer1 %>% na.omit %>% filter(cancer_type %in% input$somename & race %in% "All races")
             
             
             g <- ggplot(data = cancertype, mapping = aes(x = year, y = survival_rate, color = gender)) + geom_line() + labs(y = "Survival Rate (%)", x = " ", title = paste0(input$somename," ", "cancer", " ", "5-Year Survival")) 
             
             g
     })
     
     output$docu <- renderText({expr = "Select the type of cancer from the left panel to see the survival rate. If you are diagnosed with bladder cancer in 1990, what is the chance you will survive for five years"                                     
     })
       
        
        
}

shinyApp(ui = ui, server = server)



##