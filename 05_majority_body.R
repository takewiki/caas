menu_majority <- tabItem(tabName = "majority",
                         fluidRow(
                           column(width = 12,
                                 tabBox(title ="报表工作台",width = 12,
                                        id='tabSetRpt',height = '300px',
                                        tabPanel('智能导购报表',tagList(
                                          fluidRow(column(4,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            mdl_dateRange('um_cspDates',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            actionButton('um_cspPreview','预览报表'),
                                            mdl_download_button('um_cspInfo_dl','下载报表')
                                          )),
                                          column(8, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            
                                            div(style = 'overflow-x: scroll',mdl_dataTable('um_cspInfo','智能导购报表'))
                                          )
                                          ))
                                          
                                        )),
                                        tabPanel('内部支持报表',tagList(
                                          fluidRow(column(4,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            mdl_dateRange('um_tspDates',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            actionButton('um_tspPreview','预览报表'),
                                            mdl_download_button('um_tspInfo_dl','下载内部支持报表')
                                          )),
                                          column(8, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            div(style = 'overflow-x: scroll',mdl_dataTable('um_tspInfo','内部支持报表'))
                                          )
                                          ))
                                          
                                        )),
                                        
                                        tabPanel('千牛日志明细报表',tagList(
                                          fluidRow(column(4,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            mdl_dateRange('um_qnDates',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            
                                            selectInput('um_cspUserName',
                                                             '请选择导购员名称',
                                                           caaspkg::getCspUserName(conn_be,app_id),
                                                           ),
                                            
                                            actionButton('um_qnPreview','预览报表'),
                                            mdl_download_button('um_qnInfo_dl','下载千牛日志明细报表')
                                          )),
                                          column(8, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            div(style = 'overflow-x: scroll',mdl_dataTable('um_qnInfo','千牛日志明细报表'))
                                          )
                                          ))

                                        )),
                                        tabPanel('千牛日志有效问',tagList(
                                          fluidRow(column(4,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            #选择日期
                                            #mdl_dateRange('um_qnDates_bl',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            
                                        
                                            #上传黑名单
                                            mdl_file('um_file_qnlog_bl','选择千牛日志黑名单'),
                                            actionButton('qnlog_bl_upload','上传千牛日志黑名单至服务器'),
                                            br(),
                                            br(),
                                   
                                            mdl_date('log_qa_update_date','有效问更新日期'),
                                            #actionButton('log_qa_update_btn','日报QA对更新'),
                                            #取消此功能
                                            actionButton('um_qnlog_bl_apply','执行自动配对-打标-合并'),
                                            actionButton('um_qnlog_bl_apply_reset','再次激活运算'),
                                            br(),
                                            br(),
                                            actionButton('um_qnlog_bl_query','查询已运算标注日志'),
                                            mdl_download_button('um_qnlog_bl_dl','下载已运算标注日志')
                                           
                                  
                                          )),
                                          column(8, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            div(style = 'overflow-x: scroll', mdl_dataTable('um_qnInfo_bl','千牛日志有效问'))
                                          )
                                          ))
                                          
                                        )),
                                        
                                        tabPanel('千牛日志在线打标',tagList(
                                          fluidRow(column(3,
                                                          
                                            # box(
                                            # title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            #选择日期
                                            #mdl_dateRange('um_qnDates_bl',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            
                                            
                                   
                                            
                                            #mdl_date('log_qa_tagging_date','指定日期')
                                            dateInput(inputId = 'log_qa_tagging_date',label = '指定打标日期',value = Sys.Date(),language = 'zh-CN',weekstart = 1)
                                            #uiOutput('log_qa_tagging_ui')
                                   
                                            
                                            
                                          #)
                                          
                                          )),
                                          fluidRow(
                                          column(12,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            #选择日期
                                            #mdl_dateRange('um_qnDates_bl',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            
                                            
                                            
                                            
                                           # mdl_date('log_qa_tagging_date','指定日期'),
                                           
                                           
                                           tabBox(
                                             title = "打标工作台",width = 12,
                                             # The id lets us use input$tabset1 on the server to find the current tab
                                             id = "tabset_tagging", height = "300px",
                                             tabPanel('未打标',tagList(
                                           
                                               div(style = 'overflow-x: scroll',uiOutput('log_qa_tagging_ui'))
                                            
                                            )),
                                            tabPanel('已打标',tagList(
                                              
                                              #uiOutput('log_qa_tagging_ui')
                                               actionButton('tagging_done','获取指定日期已打标数据'),
                                               div(style = 'overflow-x: scroll',mdl_dataTable('tagging_done_dataShow'))
                                              
                                              )),
                                            tabPanel('全部',tagList(
                                              
                                             # uiOutput('log_qa_tagging_ui')
                                              actionButton('tagging_all','获取指定日期全部数据'),
                                              div(style = 'overflow-x: scroll',mdl_dataTable('tagging_all_dataShow'))
                                              
                                              )),
                                            tabPanel('下载数据',tagList(
                                              
                                              # uiOutput('log_qa_tagging_ui')
                                              fluidRow(column(6,mdl_dateRange('log_qa_res_dates','选择日期范围')),
                                                        column(3,actionButton('log_qa_res_prev','查看数据')),
                                                        column(3,mdl_download_button('log_qa_res_dl','下载数据'))
                                                       )
                                             ,
                                             fluidRow(
                                               div(style = 'overflow-x: scroll',mdl_dataTable('log_qa_res_datashow'))
                                             )
                                              
                                              
                                            ))
                                            
                                            
                                            
                                            )
                                            
                                            
                                            
                                            
                                          ))
                                          
                                          
                                          )
                                          
                                        )),
                                        tabPanel('千牛日志汇总报表',tagList(
                                          fluidRow(column(4,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            mdl_dateRange('um_qnDates2',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            actionButton('um_qnPreview2','预览报表'),
                                            mdl_download_button('um_qnInfo_dl2','下载千牛日志汇总报表')
                                            
                                          )),
                                          column(8, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            div(style = 'overflow-x: scroll', mdl_dataTable('um_qnInfo2','千牛日志汇总报表'))
                                          )
                                          ))
                                          
                                        ))
                                        
                                        
                                        
                                        )
                           )
                         )
)