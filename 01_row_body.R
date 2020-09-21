menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(12, 
                             
                             
                             fluidRow( tabBox(
                               title = "工作台",width = 12,
                               # The id lets us use input$tabset1 on the server to find the current tab
                               id = "tabset1", height = "300px",
                               tabPanel("输入", 
                                        fluidRow(column(6,    tagList(
                                          fluidRow(
                                            column(12,     box(
                                              title = "消息输入区", width = NULL, solidHeader = TRUE, status = "primary",
                                              fluidRow(column(12,mdl_text('scp_mgsinput','千牛消息(客服可编辑修改):'))
                                                       
                                              )
                                              
                                              ,
                                              fluidRow(column(8,uiOutput('csp_sel_carType_placeHolder'),
                                                              #加载复制功能
                                                              try(rclipboardSetup())),
                                                              column(4,
                                                                     materialSwitch(inputId = "csp_type_general", 
                                                                                    label = "通用问题", value = FALSE, 
                                                                                    status = "success"),
                                                                     materialSwitch(inputId = "csp_type_oilCard", 
                                                                                    label = "油卡查询", value = FALSE, 
                                                                                    status = "success")
                                                                     
                                                                     
                                                                     )),
                                              
                                              
                                              uiOutput('scp_tip'),
                                              #mdl_text('scp_modifyTxt','客服修改消息:'),
                                              fluidRow(column(12,
                                                              tags$h4('输入消息结果确认:'),
                                                              verbatimTextOutput('scp_msginput2')
                                              )),
                                              fluidRow(
                                                column(12,
                                                       #actionButton('scp_submit','查询知识库',icon('robot'))
                                                       actionBttn('scp_submit','查询知识库',icon =icon('robot'), color = 'primary',style = 'jelly'),
                                                       #油卡查询与机器人进行合并
                                                       #actionBttn('scp_submit_oilCard','油卡查询',icon =icon('address-card'), color = 'primary',style = 'jelly'),
                                                       #actionButton('oper_support5D','提交内部支持')
                                                       actionBttn('oper_support5D','提交内部支持',icon =icon('hands-helping'), color = 'warning',style = 'jelly')
                                                       
                                                )
                                                
                                              ),
                                              fluidRow(column(12,br(),
                                                              
                                                              tabBox(title = "",width = 12,
                                                                        # The id lets us use input$tabset1 on the server to find the current tab
                                                                        id = "tabset2", height = "200px",
                                                                        
                                                                        tabPanel(title = '欢迎语',
                                                                                 tagList(
                                                                                   selectInput("msg_speak", "添加话术:",
                                                                                               c("话述语1" = "请问有什么能为您服务的吗？",
                                                                                                 "话述语2" = "有什么可以帮您",
                                                                                                 "话述语3" = "有什么可以为您效劳")),
                                                                                   
                                                                                   materialSwitch(inputId = "set_speak", 
                                                                                                  label = "欢迎语独立回复", value = TRUE, 
                                                                                                  status = "primary"),
                                                                                   #actionButton('add_welcome','添加欢迎语',icon = icon('smile'))
                                                                                   actionBttn('add_welcome','添加欢迎语',icon =icon('smile'), color = 'primary',style = 'jelly',size = 'md')
                                                                                   
                                                                                 )),
                                                                        tabPanel(title = '导购语',tagList(
                                                                          selectInput("msg_sale", "添加导购语:",
                                                                                      c('导购语1' = "目前全新路虎发现运动版携纳米级净化技术护航上市，全系标配空气质量监测系统、PM2.5雾霾净化系统和纳米级车内负离子除菌系统。如您有兴趣可以点击了解详情：https://detail.tmall.com/item.htm?id=610700638815&spm=2014.21600712.0.0",
                                                                                        "导购语2" = "我们推出新车型，你是否感兴趣？",
                                                                                        "导购语3" = "我们有优惠金融方式，是否需要推送给您")),
                                                                          
                                                                          materialSwitch(inputId = "set_sale", 
                                                                                         label = "导购语独立回复", value = TRUE, 
                                                                                         status = "danger"),
                                                                          #actionButton('add_sale','添加导购',icon('shopping-cart'))
                                                                          actionBttn('add_sale','添加导购语',icon =icon('shopping-cart'), color = 'danger',style = 'jelly',size = 'md')
                                                                          
                                                                        )),
                                                                        tabPanel(title = '留资语',tagList(
                                                                          selectInput("msg_info", "添加留资语:",
                                                                                      c('留资语1' = "目前全新路虎发现运动版携纳米级净化技术护航上市，全系标配空气质量监测系统、PM2.5雾霾净化系统和纳米级车内负离子除菌系统。如您有兴趣可以点击了解详情：https://detail.tmall.com/item.htm?id=610700638815&spm=2014.21600712.0.0",
                                                                                        "留资语2" = "我们有抽奖活动，您是否要参与",
                                                                                        "留资语3" = "我们有精品可以推荐，请提供物流信息")),
                                                                          # mdl_ListChoose1('set_info',label = '留资选项',choiceNames = list('独立回复','挂购回复'),
                                                                          #                 choiceValues = list(TRUE,FALSE),selected = TRUE)
                                                                          materialSwitch(inputId = "set_info", 
                                                                                         label = "留资语独立回复", value = TRUE, 
                                                                                         status = "success"),
                                                                          #actionButton('add_info','添加留资',icon('info-circle'))
                                                                          actionBttn('add_info','添加留资语',icon =icon('info-circle'), color = 'success',style = 'jelly',size = 'md')
                                                                          
                                                                        )),
                                                                     tabPanel(title = '知识点',tagList(
                                                                       selectInput("msg_info", "知识类型:",
                                                                                   c('通用' = "通用",
                                                                                     "车型固定内容" = "车型固定内容",
                                                                                     "车型活动内容" = "车型活动内容")),
                                                                       
                                                                       actionBttn('scp_pushKK','提交知识点',icon =icon('robot'), color = 'primary',style = 'jelly')
                                                                       
                                                                     ))
                                                                        
                                                                        
                                                                        
                                                                        
                                              )
                                              ))
                                              
                                              
                                            )))
                                        )),
                                                 column(6,
                                                        box(
                                                          title = "显示结果", width = NULL, solidHeader = TRUE, status = "primary",
                                                          #添加倒计量功能,
                                                          fluidRow(
                                                            column(6,textOutput('timeleft')),
                                                            column(6,htmlOutput('timeleft2'))),
                                                          fluidRow(
                                                            column(12,
                                                                   
                                                                   
                                                                   #add here-------
                                                                   textAreaInput('scp_res',label = '消息输出编辑框',value = '知识库查询结果将显示在这里，请等待',rows = 23),
                                                                   
                                                                   fluidRow(column(12,
                                                                                   fluidRow(
                                                                                     column(6,numericInput('seconds','超时设置:',value=15,min=0,max=99999,step=1)),
                                                                                     column(6,uiOutput("clip"),materialSwitch(inputId = "clip_auto", 
                                                                                                             label = "复制后自动清除内容", value = FALSE, 
                                                                                                             status = "primary")
                                                                                            
                                                                                            )
                                                                                   )
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                   ),
                                                                   column(6,''
                                                                          
                                                                   )
                                                                   )
                                                            ))
                                                          
                                                          
                                                          
                                                          
                                                        )
                                                        ))
                                        #end for input
                                        
                                        
                                    
                                        #endFor the tagList
                                        ),
                               
                               # if(1==2){
                               #   #取消人工审核节点
                               # tabPanel("人工审核", 
                               #          tagList(fluidRow(
                               #            column(12, box(
                               #              title = "人工审核区", width = NULL, solidHeader = TRUE, status = "primary",
                               #              
                               #              tags$h5('千牛消息(查看):'),
                               #              verbatimTextOutput('show_msg2_ph'),
                               #              uiOutput('audit_placeHolder'),
                               #              # radioButtons("dist", "获取知识库问题:",
                               #              #              c("问题1" = "norm",
                               #              #                "问题2" = "unif",
                               #              #                "问题3" = "lnorm",
                               #              #                "问题4" = "exp"),selected = 'norm'),
                               #              #取消显示答案按纽，答案自动显示
                               #              # mdl_action_button('mnl_showAnsw','显示答案'),
                               #              #actionButton('mnl_confirm','确认选择'),
                               #              actionBttn('mnl_confirm','确认选择',icon =icon('check'), color = 'primary',style = 'jelly'),
                               #              #actionButton('oper_support2','提交内部支持'),
                               #              actionBttn('oper_support2','提交内部支持',icon =icon('hands-helping'), color = 'warning',style = 'jelly'),
                               #              #actionButton('show_support2','查看内部支持回复'),
                               #              actionBttn('show_support2','查看内部支持回复',icon =icon('list'), color = 'primary',style = 'jelly'),
                               #              br(),
                               #              tags$p('显示答案:'),
                               #              #mdl_print('mannal_showAnswer')
                               #              verbatimTextOutput('mannal_showAnswer')
                               #           
                               #            )))))
                               #   },
                               
                               
                               
                               tabPanel("内部支持提交", 
                                        tagList(fluidRow(
                                          column(12,   box(
                                            title = "消息获取区", width = NULL, solidHeader = TRUE, status = "primary",
                                            tags$h5('千牛消息(查看):'),
                                            verbatimTextOutput('show_msg3_ph'),
                                            # actionButton('spt_getMsg','提交内部支持'),
                                           # actionButton('show_support3','查看内部支持回复')
                                            actionBttn('show_support3','查看内部支持回复',icon =icon('list'), color = 'primary',style = 'jelly')
                                           
                                          ))))),
                               tabPanel("油卡上传", 
                                        tagList(fluidRow(
                                         
                                          column(4,   box(
                                            title = "油卡操作区", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            mdl_file('oilCard_upload_file','请选择上传的油卡xlsx数据'),
                                            br(),
                                            actionButton('oilCard_upload_submit','上传服务器'),
                                            actionButton('oilCard_upload_submit_reset','再次上传')
                                            
                                          )),
                                          column(8,   box(
                                            title = "油卡查询区", width = NULL, solidHeader = TRUE, status = "primary",
                                            ''
                                            
                                            # mdl_dataTable('scp_oilCard_dataShow','显示油卡信息'),
                                            # br(),
                                            # actionBttn('scp_oilCard_backtoInput','返回到输入')
                                            
                                          ))
                                          
                                          
                                          ))),
                               
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
                                          ))))),
                               tabPanel("上传千牛日志", 
                                        tagList(fluidRow(
                                          column(4,   box(
                                            title = "日志操作区", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            mdl_file('upload_cl_batch','上传千牛日志文件',fileType = '.txt'),
                                            textInput('cl_status','数据上传状态:','准备中'),
                                            actionButton('cl_upload_preview','预览日志'),
                                            actionButton('cl_upload_done','上传服务器'),
                                            actionButton('cl_upload_done_reset','再次激活上传')
                                          )),
                                          column(8,
                                                 box(
                                                   title = "日志预览区", width = NULL, solidHeader = TRUE, status = "primary",
                                                   
                                                   div(style = 'overflow-x: scroll',mdl_dataTable('dt_cl_batch'))
                                                 )
                                                 
                                                 )))),
                               tabPanel("日志历史记录", 
                                        tagList(fluidRow(
                                          column(4,   box(
                                            title = "日志操作区", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            mdl_dateRange('logQuery_dates','查询范围',startDate = Sys.Date()-30,endDate = Sys.Date()),
                                            actionButton(inputId = 'logQuery_preview','预览日志'),
                                            mdl_download_button('logQuery_dl','下载日志历史')
                                          )),
                                          column(8,
                                                 box(
                                                   title = "日志预览区", width = NULL, solidHeader = TRUE, status = "primary",
                                                   
                                                   div(style = 'overflow-x: scroll',mdl_dataTable('logQuery_dataShow'))
                                                 )
                                                 
                                          ))))
                               
                               
                               
                             )),
                             fluidRow(
                               column(12,  #code here
                                    ''
                                      )
                             
                             )
                             
                             
                            
                      
                   
                      
                      
                      )

                      
                    )
)

