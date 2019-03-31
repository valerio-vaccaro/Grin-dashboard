## ui.R ##
library(shinydashboard)
library(leaflet)

ui <- dashboardPage(
        dashboardHeader(title = "Grin" ),
        
        ## Sidebar content
        dashboardSidebar(
                sidebarMenu(
                        menuItem("Statistics", tabName = "dashboard_statistics", icon = icon("dashboard")),
                        menuItem("Data", tabName = "dashboard_data", icon = icon("dashboard")),
                        menuItem("Credits", tabName = "credits", icon = icon("th")),
                        checkboxGroupInput("checkGroup", 
                                          label = "edge bits", 
                                          choices = list(
                                            "29" = 1, 
                                            "31" = 2, 
                                            "32" = 3),
                                          selected = c(1,2,3)),
                        uiOutput("dateSelector"),
                        radioButtons("radio", label = "Period",
                            choices = list("Last day" = 1, "Last week" = 2, "Last month" = 3), 
                            selected = 2)
                )
        ),
        dashboardBody(
                tags$head(tags$link(rel = "shortcut icon", href = "http://vaccaro.tech/favicon.ico")),
                tabItems(
                        # dashboard content
                        tabItem(tabName = "dashboard_statistics",
                                fluidRow(
                                        infoBoxOutput("dateBox"),
                                        infoBoxOutput("speedBox"),
                                        infoBoxOutput("pulseBox")
                                ),
                                fluidRow(
                                        box(title = "", status = "primary", solidHeader = TRUE,
                                            plotOutput("a11", height = 300) ),
                                        box(title = "", status = "primary", solidHeader = TRUE,
                                            plotOutput("a12", height = 300) )
                                ),
                                fluidRow(
                                   box(title = "", status = "primary", solidHeader = TRUE,
                                       plotOutput("a21", height = 300) ),
                                   box(title = "", status = "primary", solidHeader = TRUE,
                                       plotOutput("a22", height = 300) )
                                ),
                                fluidRow(
                                  box(title = "", status = "primary", solidHeader = TRUE,
                                      plotOutput("a31", height = 300) ),
                                  box(title = "", status = "primary", solidHeader = TRUE,
                                      plotOutput("a32", height = 300) )
                                ),
                                fluidRow(
                                  box(title = "", status = "primary", solidHeader = TRUE,
                                      plotOutput("a41", height = 300) ),
                                  box(title = "", status = "primary", solidHeader = TRUE,
                                      plotOutput("a42", height = 300) )
                                )
                        ),
                        
                        # dashboard content
                        tabItem(tabName = "dashboard_data",
                                fluidRow(
                                        column(4, dataTableOutput('data')
                                        )
                                )
                        ),
                       
                        # credits content
                        tabItem(tabName = "credits",
                                tags$a(
                                   href="https://github.com/valerio-vaccaro/Grin-dashboard/",
                                   tags$img(
                                      style="position: absolute; top: 10; right: 0; border: 0;",
                                      src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png",
                                      alt="Fork me on GitHub"
                                   )
                                ),
                                h2("Grin activity"),
                                "Grin activity is a dashboard developed in R and shiny and able to show some summaries on Grin chain.", br(),
                                br(),"All the code is available at", a("https://github.com/valerio-vaccaro/Grin-dashboard"), br(),
                                br(),"Copyright (c) 2019 Valerio Vaccaro", a("http://www.valeriovaccaro.it"), br(),
                                br(),"Permission is hereby granted, free of charge, to any person obtaining a copy", br(),
                                "of this software and associated documentation files (the \"Software\"), to deal", br(),
                                "in the Software without restriction, including without limitation the rights", br(),
                                "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell", br(),
                                "copies of the Software, and to permit persons to whom the Software is", br(),
                                "furnished to do so, subject to the following conditions:", br(),
                                br(),"The above copyright notice and this permission notice shall be included in all", br(),
                                "copies or substantial portions of the Software.", br(),
                                br(),"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR", br(),
                                "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,", br(),
                                "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE", br(),
                                "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER", br(),
                                "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,", br(),
                                "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE", br(),
                                "SOFTWARE."
                        )
                )
        )
)