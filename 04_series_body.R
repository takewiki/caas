menu_series<- tabItem(tabName = "series",
                      fluidRow(
                        column(width = 12,
                               tabBox(
                                 title = "工作台",width = 12,
                                 # The id lets us use input$tabset1 on the server to find the current tab
                                 id = "tabset_cnlk", height = "300px",
                                 tabPanel("查看知识分类", 
                                          tagList(
                                            fluidRow(
                                              column(width = 4,
                                                     box(
                                                       title = "操作区", width = NULL, solidHeader = TRUE, status = "primary",
                                                      
                                                       actionButton('kms_queryKc','查看知识分类列表')
                                                    
                                                       ,use_pop()
                                                     )
                                                     
                                              ),
                                              
                                              column(width = 8,
                                                     box(
                                                       title = "数据预览", width = NULL, solidHeader = TRUE, status = "primary",
                                                       mdl_dataTable('kms_dataTable_KcList')
                                                     )
                                              )
                                            )
                                          )
                                 ),
                                 
                                 tabPanel("新增知识点", 
                                          tagList(
                                            fluidRow(
                                              column(width = 12,
                                                     box(
                                                       title = "新增知识点", width = NULL, solidHeader = TRUE, status = "primary",
                                                       mdl_text('kc_new_name','知识分类名称'),
                                                       mdl_text('kn_new_name','标准问名称'),
                                                      #mdl_text('kk_new_name','标准答名称'),
                                                       actionButton('kn_createOne','新增知识点'),
                                                       uiOutput('kn_new_create')
                                                     )
                                              ))
                                            
                                          )),
                                 tabPanel("更新知识点", 
                                          tagList(
                                            fluidRow(
                                              column(width = 12,
                                                     box(
                                                       title = "更新知识点", width = NULL, solidHeader = TRUE, status = "primary",
                                                       uiOutput('kn_update')
                                                     )
                                              ))
                                            
                                          ))
                                 
                                 
                                 
                               )
                        )
                      ))