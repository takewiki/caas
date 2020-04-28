menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(12, 
                             
                             
                             fluidRow( tabBox(
                               title = "工作台",width = 12,
                               # The id lets us use input$tabset1 on the server to find the current tab
                               id = "tabset1", height = "300px",
                               tabPanel("输入", 
                                        tagList(
                                          fluidRow(
                                            column(12,     box(
                                              title = "消息输入区", width = NULL, solidHeader = TRUE, status = "primary",
                                              fluidRow(column(9,mdl_text('scp_mgsinput','千牛消息(客服可编辑修改):')),
                                                       column(3,
                                                              uiOutput('csp_sel_carType_placeHolder')
                                                              
                                                              )
                                                       )
                                              ,
                                             
                                              # br(),
                                             
                                              #【相似问题】纵向显示
                                              # radioButtons("dist", "相似问题:",
                                              #              c("相似问题1" = "norm",
                                              #                "相似问题2" = "unif",
                                              #                "相似问题3" = "lnorm",
                                              #                "相似问题4" = "exp"),inline = FALSE),
                                              #相似问
                                              uiOutput('scp_tip'),
                                              #mdl_text('scp_modifyTxt','客服修改消息:'),
                                              fluidRow(column(12,
                                                              tags$h4('输入消息结果确认:'),
                                                              verbatimTextOutput('scp_msginput2')
                                                              )),
                                              fluidRow(
                                                column(2,actionButton('scp_submit','查询知识库',icon('robot')))
                                                # 取消人工干预,自动跳转
                                                # ,
                                                # column(6,
                                                #        
                                                #        checkboxGroupInput('scp_res',NULL,
                                                #                           choiceNames = list('确认答案','人工审核','内部支持'),
                                                #                           choiceValues =list('auto','manual','support'),inline = T )),
                                                # column(4,actionButton('scp_act_m','进入人工审核'),
                                                #         actionButton('scp_act_s','进入内部支持'))
                                              )
                                              
                                              
                                            )))
                                        )),
                               tabPanel("人工审核", 
                                        tagList(fluidRow(
                                          column(12, box(
                                            title = "人工审核区", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            tags$h5('千牛消息(查看):'),
                                            verbatimTextOutput('show_msg2_ph'),
                                            uiOutput('audit_placeHolder'),
                                            # radioButtons("dist", "获取知识库问题:",
                                            #              c("问题1" = "norm",
                                            #                "问题2" = "unif",
                                            #                "问题3" = "lnorm",
                                            #                "问题4" = "exp"),selected = 'norm'),
                                            #取消显示答案按纽，答案自动显示
                                            # mdl_action_button('mnl_showAnsw','显示答案'),
                                            actionButton('mnl_confirm','确认选择'),
                                            actionButton('oper_support2','提交内部支持'),
                                            actionButton('show_support2','查看内部支持回复'),
                                            br(),
                                            tags$p('显示答案:'),
                                            #mdl_print('mannal_showAnswer')
                                            verbatimTextOutput('mannal_showAnswer')
                                         
                                          ))))),
                               tabPanel("内部支持提交", 
                                        tagList(fluidRow(
                                          column(12,   box(
                                            title = "消息获取区", width = NULL, solidHeader = TRUE, status = "primary",
                                            tags$h5('千牛消息(查看):'),
                                            verbatimTextOutput('show_msg3_ph'),
                                            # actionButton('spt_getMsg','提交内部支持'),
                                            actionButton('show_support3','查看内部支持回复')
                                           
                                          ))))),
                               
                               tabPanel("内部支持-领答", 
                                        tagList(fluidRow(
                                          column(12,   box(
                                            title = "消息查询区", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            uiOutput('books')
                                          ))))),
                               tabPanel("内部支持-催单", 
                                        tagList(fluidRow(
                                          column(12,   box(
                                            title = "消息查询区", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            uiOutput('books2')
                                          )))))
                               
                               
                             )),
                             fluidRow(
                               column(12,  #code here
                                      box(
                                        title = "显示结果", width = NULL, solidHeader = TRUE, status = "primary",
                                        fluidRow(
                                          column(8,
                                                 #mdl_print('msg_print'),
                                                 verbatimTextOutput('msg_print'),
                                                 #mdl_text('scp_km_res1','消息输出结果'),
                                                 uiOutput('scp_res_ph'),
                                                 fluidRow(column(6,
                                                                 uiOutput("clip"),
                                                                 actionButton('add_sale','添加导购',icon('shopping-cart')),
                                                                 actionButton('add_info','添加留资',icon('info-circle'))
                                                                 
                                                 ),
                                                 column(6,checkboxInput('scp_oper_auto','20秒超时自动回复',value = TRUE))
                                                 )
                                                 ),
                                          column(4,
                                                 fluidRow(  box(
                                                   title = "欢迎语设置", status = "primary", width = 12,solidHeader = FALSE,
                                                   collapsible = TRUE,collapsed = TRUE,background = 'black',
                                                   #2.01.01工具栏选项--------
                                                   
                                                   
                                                   selectInput("msg_speak", "添加话术:",
                                                               c("话述语1" = "请问有什么能为您服务的吗？",
                                                                 "话述语2" = "am",
                                                                 "话述语3" = "gear")),
                                                   mdl_ListChoose1('set_speak',label = '欢迎语选项',choiceNames = list('独立回复','挂购回复'),
                                                                   choiceValues = list(TRUE,FALSE),selected = TRUE)
                                                   
                                                   
                                                 ))
                                                 ,
                                                 fluidRow( box(
                                                   #2.01.02坐标轴选项-----
                                                   title = "导购语设置", status = "primary", width = 12,solidHeader = FALSE,
                                                   collapsible = TRUE,collapsed = TRUE,background = 'black',
                                                   # 2.01.02.01是否交互X与Y轴------
                                                   #业务对象设置
                                                   
                                                   selectInput("msg_sale", "添加导购语:",
                                                               c('导购语1' = "目前全新路虎发现运动版携纳米级净化技术护航上市，全系标配空气质量监测系统、PM2.5雾霾净化系统和纳米级车内负离子除菌系统。如您有兴趣可以点击了解详情：https://detail.tmall.com/item.htm?id=610700638815&spm=2014.21600712.0.0",
                                                                 "导购语2" = "am",
                                                                 "导购语3" = "gear")),
                                                   mdl_ListChoose1('set_sale',label = '导购选项',choiceNames = list('独立回复','挂购回复'),
                                                                   choiceValues = list('1','2'),selected = '1'),
                                                   selectInput("msg_info", "添加留资语:",
                                                               c('留资语1' = "目前全新路虎发现运动版携纳米级净化技术护航上市，全系标配空气质量监测系统、PM2.5雾霾净化系统和纳米级车内负离子除菌系统。如您有兴趣可以点击了解详情：https://detail.tmall.com/item.htm?id=610700638815&spm=2014.21600712.0.0",
                                                                 "留资语2" = "am",
                                                                 "留资语3" = "gear")),
                                                   mdl_ListChoose1('set_info',label = '留资选项',choiceNames = list('独立回复','挂购回复'),
                                                                   choiceValues = list(TRUE,FALSE),selected = TRUE)
                                                   
                                                   
                                                   
                                                 ))
                                                 ))
                        
                                        
                                        
                                 
                                      )
                                      )
                             
                             )
                             
                             
                            
                      
                   
                      
                      
                      )

                      
                    )
)

