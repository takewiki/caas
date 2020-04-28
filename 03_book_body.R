menu_book <- tabItem(tabName = "book",
                     fluidRow(
                       column(width = 12,
                              tabBox(
                                title = "工作台",width = 12,
                                # The id lets us use input$tabset1 on the server to find the current tab
                                id = "tabset1", height = "300px",
                                tabPanel("上传品牌车型", 
                                         tagList(
                                           fluidRow(
                                             column(width = 4,
                                                    box(
                                                      title = "上传品牌车型", width = NULL, solidHeader = TRUE, status = "primary",
                                                      mdl_file('file_brandCartype','上传品牌车型文件')
                                                      ,actionButton('btn_carType','预览品牌车型数据')
                                                      ,actionButton('upload_carType','上传服务器')
                                                      ,use_pop()
                                                    )
                                                    
                                             ),
                                             
                                             column(width = 8,
                                                    box(
                                                      title = "车型数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                                      mdl_dataTable('pre_carType')
                                                    )
                                             )
                                           )
                                         )
                                ),
                                tabPanel("修改已有车型", 
                                         tagList(
                                           fluidRow(
                                             column(width = 12,
                                                    box(
                                                      title = "品牌车型修改", width = NULL, solidHeader = TRUE, status = "primary",
                                                      uiOutput('editCarType')
                                                    )
                                             ))
                                           
                                         ))
                                
                                
                              )
                       )
                     ))