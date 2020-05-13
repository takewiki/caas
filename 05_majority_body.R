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
                                            
                                            mdl_dataTable('um_cspInfo','智能导购报表')
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
                                            mdl_dataTable('um_tspInfo','内部支持报表')
                                          )
                                          ))
                                          
                                        )),
                                        #2020-05-13
                                        #callation the using for perfomance 
                                        # tabPanel('千牛日志明细报表',tagList(
                                        #   fluidRow(column(4,box(
                                        #     title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        #     mdl_dateRange('um_qnDates',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                        #     actionButton('um_qnPreview','预览报表'),
                                        #     mdl_download_button('um_qnInfo_dl','下载千牛日志明细报表')
                                        #   )),
                                        #   column(8, box(
                                        #     title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                        #     mdl_dataTable('um_qnInfo','千牛日志明细报表')
                                        #   )
                                        #   ))
                                        #   
                                        # )),
                                        tabPanel('千牛日志汇总报表',tagList(
                                          fluidRow(column(4,box(
                                            title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            mdl_dateRange('um_qnDates2',label = '报表日期范围选择',startDate = Sys.Date()-7,endDate = Sys.Date()),
                                            actionButton('um_qnPreview2','预览报表'),
                                            mdl_download_button('um_qnInfo_dl2','下载千牛日志汇总报表')
                                          )),
                                          column(8, box(
                                            title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                            mdl_dataTable('um_qnInfo2','千牛日志汇总报表')
                                          )
                                          ))
                                          
                                        ))
                                        
                                        
                                        
                                        )
                           )
                         )
)