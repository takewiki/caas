menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(12, 
                                
                                
                                fluidRow( tabBox(
                                  title = "工作台",width = 12,
                                  # The id lets us use input$tabset1 on the server to find the current tab
                                  id = "tabset1", height = "300px",
                                  tabPanel("待支持新问题-加急", 
                                           tagList(
                                             fluidRow(
                                               column(12,     box(
                                                 title = "加急处理区", width = NULL, solidHeader = TRUE, status = "primary",
                                                 
                                                 uiOutput('tcp_prior1'),
                                                 
                                                 
                                                 
                                                 
                                               )))
                                           )),
                                  tabPanel("待支持新问题-普通", 
                                           tagList(fluidRow(
                                             column(12, box(
                                               title = "普通处理区", width = NULL, solidHeader = TRUE, status = "primary",
                                               
                                               
                                               uiOutput('tcp_prior2')
                                               
                                               
                                             ))))),
                                  tabPanel("可修改答案问题清单", 
                                           tagList(fluidRow(
                                             column(12,   box(
                                               title = "今日处理区", width = NULL, solidHeader = TRUE, status = "primary",
                                               
                                               uiOutput('tcp_prior3A')
                                               
                                               
                                             ))))),
                                  tabPanel("今日已处理问题清单", 
                                           tagList(fluidRow(
                                             column(12,   box(
                                               title = "今日查询区", width = NULL, solidHeader = TRUE, status = "primary",
                                               
                                               uiOutput('tcp_prior3B')
                                               
                                               
                                             ))))),
                                  tabPanel("全部已处理问题清单", 
                                           tagList(fluidRow(
                                             column(12,   box(
                                               title = "全部查询区", width = NULL, solidHeader = TRUE, status = "primary",
                                               
                                               
                                               uiOutput('tcp_prior4')
                                             )))))
                                  
                                ))
                         ))
)
