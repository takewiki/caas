

#shinyserver start point----
 shinyServer(function(input, output,session) {
    
    #00-基础框设置-------------
    #读取用户列表
    user_base <- getUsers(conn_be,app_id)
    

   
   credentials <- callModule(shinyauthr::login, "login", 
                             data = user_base,
                             user_col = Fuser,
                             pwd_col = Fpassword,
                             hashed = TRUE,
                             algo = "md5",
                             log_out = reactive(logout_init()))
   
   
   
   logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
   
   observe({
     if(credentials()$user_auth) {
       shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
     } else {
       shinyjs::addClass(selector = "body", class = "sidebar-collapse")
     }
   })
   
   user_info <- reactive({credentials()$info})
   
   #显示用户信息
   output$show_user <- renderUI({
     req(credentials()$user_auth)
      
      dropdownButton(
         fluidRow(  box(
            title = NULL, status = "primary", width = 12,solidHeader = FALSE,
            collapsible = FALSE,collapsed = FALSE,background = 'black',
            #2.01.01工具栏选项--------
            
            
            actionLink('cu_updatePwd',label ='修改密码',icon = icon('gear') ),
            br(),
            br(),
            actionLink('cu_UserInfo',label = '用户信息',icon = icon('address-card')),
            br(),
            br(),
            actionLink(inputId = "closeCuMenu",
                         label = "关闭菜单",icon =icon('window-close' ))
            
            
         )) 
      ,
         circle = FALSE, status = "primary", icon = icon("user"), width = "100px",
         tooltip = FALSE,label = user_info()$Fuser,right = TRUE,inputId = 'UserDropDownMenu'
      )
      #
    
     
   })
   
   observeEvent(input$closeCuMenu,{
      toggleDropdownButton(inputId = "UserDropDownMenu")
   }
                )
   
   #修改密码
   observeEvent(input$cu_updatePwd,{
      req(credentials()$user_auth)
      
      showModal(modalDialog(title = paste0("修改",user_info()$Fuser,"登录密码"),
                         
                         mdl_password('cu_originalPwd',label = '输入原密码'),
                         mdl_password('cu_setNewPwd',label = '输入新密码'),
                         mdl_password('cu_RepNewPwd',label = '重复新密码'),
                         
                         footer = column(shiny::modalButton('取消'),
                                         shiny::actionButton('cu_savePassword', '保存'),
                                         width=12),
                         size = 'm'
      ))
   })
   
   #处理密码修改
   
   var_originalPwd <-var_password('cu_originalPwd')
   var_setNewPwd <- var_password('cu_setNewPwd')
   var_RepNewPwd <- var_password('cu_RepNewPwd')
   
   observeEvent(input$cu_savePassword,{
      req(credentials()$user_auth)
      #获取用户参数并进行加密处理
      var_originalPwd <- password_md5(var_originalPwd())
      var_setNewPwd <-password_md5(var_setNewPwd())
      var_RepNewPwd <- password_md5(var_RepNewPwd())
      check_originalPwd <- password_checkOriginal(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_originalPwd)
      check_newPwd <- password_equal(var_setNewPwd,var_RepNewPwd)
      if(check_originalPwd){
         #原始密码正确
         #进一步处理
         if(check_newPwd){
            password_setNew(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_setNewPwd)
            pop_notice('新密码设置成功:)') 
            shiny::removeModal()
            
         }else{
            pop_notice('两次输入的密码不一致，请重试:(') 
         }
         
         
      }else{
         pop_notice('原始密码不对，请重试:(')
      }
      
      
      
      
      
   }
                )
   
   
   
   #查看用户信息
   
   #修改密码
   observeEvent(input$cu_UserInfo,{
      req(credentials()$user_auth)
      
      user_detail <-function(fkey){
         res <-tsui::userQueryField(conn = conn_be,app_id = app_id,user =user_info()$Fuser,key = fkey)
         return(res)
      } 
        
      
      showModal(modalDialog(title = paste0("查看",user_info()$Fuser,"用户信息"),
                            
                            textInput('cu_info_name',label = '姓名:',value =user_info()$Fname ),
                            textInput('cu_info_role',label = '角色:',value =user_info()$Fpermissions ),
                            textInput('cu_info_email',label = '邮箱:',value =user_detail('Femail') ),
                            textInput('cu_info_phone',label = '手机:',value =user_detail('Fphone') ),
                            textInput('cu_info_qianniu',label = '千牛账号:',value =user_detail('Fqianniu') ),
                            textInput('cu_info_rpa',label = 'RPA账号:',value =user_detail('Frpa') ),
                            textInput('cu_info_dept',label = '部门:',value =user_detail('Fdepartment') ),
                            textInput('cu_info_company',label = '公司:',value =user_detail('Fcompany') ),
                            
                            
                            footer = column(shiny::modalButton('确认(不保存修改)'),
                                         
                                            width=12),
                            size = 'm'
      ))
   })
   
   
   
   #针对用户信息进行处理
   
   sidebarMenu <- reactive({
      
      res <- setSideBarMenu(conn_rds('rdbe'),app_id,user_info()$Fpermissions)
      return(res)
   })
   
   
   #针对侧边栏进行控制
   output$show_sidebarMenu <- renderUI({
      if(credentials()$user_auth){
         return(sidebarMenu())
      } else{
         return(NULL) 
      }
         
      
   })
   
   #针对工作区进行控制
   output$show_workAreaSetting <- renderUI({
      if(credentials()$user_auth){
         return(workAreaSetting)
      } else{
         return(NULL) 
      }
      
      
   })
   

   
  #01-功能模板设置---------- 
   
   
   #1.1获取消息-----
   msg <- var_text('scp_mgsinput')
   
   
   #1.1.1获取车型选项-------
   
   #添加内容
   output$csp_sel_carType_placeHolder <- renderUI({
      selectInput("csp_sel_carType", "业务对象设置:",
                  csppkg::getCarType(),selected = '发现运动版')
      
      
   }
   )
   
   
   
   
   
   #1.2添加业务对象-------
   msg2 <-reactive({
      msg <- msg()
      #Sys.sleep(20)
      if(is.null(input$csp_sel_carType)){
         var_type <-'发现运动版'
      }else{
         var_type <-input$csp_sel_carType
      }
      
      res <- tsdo::str_add(msg,var_type)
      return(res)
   })
   
   
   #1.3设置相似问-----------
   ques_tip <- reactive({
      keyword <-msg2()
      res <- ai_tip(keyword,3)
      #print(res)
      res <- unique(c(keyword,res))
      res <-vect_as_list(res)
      #print(res)
      return(res)
      
      
   })
   #1.3.1设置相似问结果显示-----
   output$scp_tip <- renderUI({
      mdl_ListChoose1(id='scp_mgsinput3',label = '相似问提示',choiceNames = ques_tip(),choiceValues = ques_tip(),selected = msg2())
   })
   
   #1.3.2 获取用户选择--------
   
   msg_input_raw3 <-var_ListChoose1('scp_mgsinput3')
   msg3 <- reactive({
      res <- msg_input_raw3()
      #print(res)
      return(res)
   })
   
   
   #***1.3.3记录用户问题--------
   csp_FQuesText <-msg3
   
   
   
   
   
   
   
   #1.4打印消息-----------
   output$scp_msginput2 <- renderPrint({
      cat(msg3())
   })
   
   #针对消息进行处理
   
   #1.5查询知识库--------
   data <- eventReactive(input$scp_submit,{
      keyword <- msg3()
      res =ai2(keyword,3,0.75,0.85)
      # print(res)
      #分情况进行情况
      return(res)
      
   })
   
   #1.6.0添加计时-------
   #添加超时功能----------
   # Initialize the timer, 10 seconds, not active.
   # intial_sec <- reactive({input$seconds})
   timer <- reactiveVal(15)
   active <- reactiveVal(FALSE)
   
   # Output the time left.
   output$timeleft <- renderText({
      paste("已用时: ", seconds_as_Timetext(input$seconds-timer()),"倒计时: ", seconds_as_Timetext(timer()))
   })
   
   
   
   output$timeleft2 <- renderText({ 
      
      if(timer() >6){
         NULL
      }else{
         paste("最后倒计时","<font color=\"#FF0000\"><b>", seconds_as_Timetext(timer()), "</b></font>") 
         
      }
      
   })
   
   # observer that invalidates every second. If timer is active, decrease by one.
   observe({
      invalidateLater(1000, session)
      isolate({
         if(active())
         {
            timer(timer()-1)
            if(timer()<1)
            {
               active(FALSE)
               updateTextAreaInput(session,'scp_res',label = '消息输出编辑框--自动回复',value = '超时自动回复内容测试')
               showModal(modalDialog(
                  title = "超时提醒",
                  "时间已到", footer = column(shiny::modalButton('确认'),
                                          
                                          width=12)
               ))
            }
         }
      })
   })
   




   
   
   
   #1.6提交服务器---------
   observeEvent(input$scp_submit,{
      #处理相关内容
      # print(as.integer(input$oper_support5D) )
      # print(as.integer(input$oper_support5D) == 0 )
      # print(as.integer(input$oper_support2))
      # print(as.integer(input$oper_support2) == 0)
      #添加计时功能
         timer(input$seconds)
         active(TRUE)
      
      #加载相关内容
      req(credentials()$user_auth)
      
      res <- data()
      print('知识库查询内容')
      print(res)
      type = res$type
      answ = res$answ
      
      #choiceValue = answ$Answ
      #针对确认问题的处理
      if (type == 'A'){
         #显示系统结果
         # run_print('msg_print',answ)
         # output$msg_print <- renderPrint({
         #    cat(answ$FAnsw[1])
         # })
         
         # output$scp_res_ph <-renderUI({
         #    #info = paste(answ,input$msg_sale,sep="\n")
         #    textAreaInput('scp_res',label = '消息输出编辑框',value = answ$FAnsw[1],rows = 3)
         # })
         
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框--类型A1',value = answ$FAnsw[1])
         
         #写入客服日志
         
         
         icLogUpload(conn=conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = answ,index = 1,type = type,forHelp = as.integer(input$oper_support5D))
         #写入AI查询日志
         queryLog_upload(conn = conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = answ)
         
         
         
         
      }else if(type =='B'){
         updateTabsetPanel(session, "tabset1",
                           selected = "人工审核")
         choiceData = tsdo::vect_as_list(answ$FQues)
         output$audit_placeHolder <-renderUI({
            mdl_ListChoose1('audit_ques','获取知识库问题:',
                            choiceNames = choiceData,
                            choiceValues =list(1,2,3),selected = 1 )
            
         })
         
         
         
      }else if (type=='C'){
         updateTabsetPanel(session, "tabset1",
                           selected = "内部支持提交")
         ques_commit(FQues = msg2(),FCspName = user_info()$Fuser,FTspName = tsp_name)
         
         #写入操作日志
         icLogUpload(conn=conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = answ,index = 1,type = type)
         #写入查询日志
         queryLog_upload(conn = conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = answ)
         #提示框
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框--类型C',value = "你的需求我们已经收到，我与我们领导沟通后第一时间回复您")
         shinyalert::shinyalert("友情提示!", '已提交内部支持!请耐心等待或紧急催单', type = "info")
         
         
         
         
      }else{
         print('error')
      }
      
      
      
      
      
   })
   
   
   
   
   #1.6.1 显示答案审核消息，用于预览，不是用户的真正选择-----------------
   
   
   output$mannal_showAnswer <- renderPrint({
      res <-data()
      #print(res$answ$)
      type = res$type
      value = var_ListChoose1('audit_ques')
      #print(value)
      #print(value())
      
      if(type == 'B'){
         cat(res$answ$FAnsw[as.integer(value())])
         
      }else{
         print('其他')
      }
      
      
   })
   
   
   #复制消息到人工审核
   output$show_msg2_ph <- renderPrint({
      cat(msg())
   })
   output$show_msg3_ph <- renderPrint({
      cat(msg())
   })
   
   
   #***1.6.2处理人工处理确认选择结果----------
   
   observeEvent(input$mnl_confirm,{
      res <-data()
      #print(res$answ$)
      type = res$type
      value = var_ListChoose1('audit_ques')
      #print(value)
      #print(value())
      
      if(type == 'B'){
         #run_print('msg_print',res$answ$FAnsw[as.integer(value())])
         # output$msg_print <- renderPrint({
         #    cat(res$answ$FAnsw[as.integer(value())])
         # })
         #写入日志
         icLogUpload(conn=conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = res$answ,index = as.integer(value()),type = type,forHelp = as.integer(input$oper_support2))
         #写入查询日志
         queryLog_upload(conn = conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = res$answ)
         #处理编辑框
         # output$scp_res_ph <-renderUI({
         #    textAreaInput('scp_res',label = '消息输出编辑框',value = res$answ$FAnsw[as.integer(value())],rows = 3)
         # })
         
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框--类型B1',value = res$answ$FAnsw[as.integer(value())])
         
      }else{
         print('其他')
      }
      
      updateTabsetPanel(session, "tabset1",
                        selected = "输入")
      
      
   })
   
   
   #处理消息复制功能
   # Add clipboard buttons
   # output$clip <- renderUI({
   #    rclipButton("clipbtn", "复制答案", input$scp_res, icon("clipboard"))
   # })
   
   # # Workaround for execution within RStudio version < 1.2
   # observeEvent(input$clipbtn, {try(clipr::write_clip(input$scp_res,allow_non_interactive = T))})
   
   
   #run_print('mannal_showAnswer','显示人工审核答案')
   
   
   
   #查看内部支持回复
   observeEvent(input$show_support2,{
      updateTabsetPanel(session, "tabset1",
                        selected = "内部支持-领答")
      
   })
   
   observeEvent(input$show_support3,{
      updateTabsetPanel(session, "tabset1",
                        selected = "内部支持-领答")
      
   })
   
   #33处理内部支持事项------
   
   # observeEvent(input$spt_getMsg,{
   #    ques_commit(FQues = msg2())
   #    shinyalert::shinyalert("友情提示!", '已提交内部支持!请耐心等待或紧急催单', type = "info")
   # })
   # 
   
   observeEvent(input$oper_support2,{
      req(credentials()$user_auth)
      res <-data()
      type = res$type
      answ = res$answ
      ques_commit(FQues = msg2(),FCspName =user_info()$Fuser,FTspName = tsp_name )
      #写入日志
      icLogUpload(conn=conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = res$answ,index = 1,type = type,forHelp = as.integer(input$oper_support2))
      updateTextAreaInput(session,'scp_res',label = '消息输出编辑框--类型B0',value = "你的需求我们已经收到，我与我们领导沟通后第一时间回复您")
      shinyalert::shinyalert("友情提示!", '已提交内部支持!请耐心等待或紧急催单', type = "info")
   })
   
   
   observeEvent(input$oper_support5D,{
      req(credentials()$user_auth)
      res <- data()
      type = res$type
      answ = res$answ
      ques_commit(FQues = msg2(),FCspName =user_info()$Fuser,FTspName = tsp_name )
      #写入日志
      icLogUpload(conn=conn,FNickName = user_info()$Fuser,FQuesText = msg3(),answ = res$answ,index = 1,type = type,forHelp = as.integer(input$oper_support5D))
      updateTextAreaInput(session,'scp_res',label = '消息输出编辑框--类型A0',value = "你的需求我们已经收到，我与我们领导沟通后第一时间回复您")
      shinyalert::shinyalert("友情提示!", '已提交内部支持!请耐心等待或紧急催单', type = "info")
   })
   
   #添加复制功能-----
   output$clip <- renderUI({
      try({
         rclipButton("clipbtn", "复制到千牛", input$scp_res, icon("clipboard"))
         
      })
   })
   
   #处理复制后事项---
   
   observeEvent(input$clipbtn,{
      active(FALSE)
      if(input$clip_auto){
        updateTextAreaInput(session,'scp_res',label = '消息输出编辑框-复制后内容已清除',value = '') 
      }
   })
   
   #添加计时处理
   #observeEvent(input$stop, {})
   
   #添加导购语-----
   #var_set_sale <- var_ListChoose1('set_sale')
 
   observeEvent(input$add_sale,{
      
      msg_sale <- input$msg_sale
      #opt_sale <-var_set_sale()
      opt_sale <- input$set_sale
      
      if(opt_sale){
         #独立回复
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框',value = msg_sale)
         
      }else{
         
         #挂钩
         msg_sale2 <- paste0(input$scp_res,msg_sale)
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框',value = msg_sale2)
         
      }
      
      
      
   })
   
   
   #添加留资-----
   #var_set_info <- var_ListChoose1('set_info')
   observeEvent(input$add_info,{
      
      msg_info <- input$msg_info
      #opt_info <-var_set_info()
      opt_info <-input$set_info
      if(opt_info){
         #独立回复
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框',value = msg_info)
         
      }else{
         #挂钩
         msg_info2 <- paste0(input$scp_res,msg_info)
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框',value = msg_info2)
         
      }
      
   })
   
   
   #处理留资信息-------
   

   
   observeEvent(input$add_welcome,{
      
      msg_speak <- input$msg_speak
 
      opt_speak <-input$set_speak
      if(opt_speak){
         #独立回复
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框',value = msg_speak)
         
      }else{
         #挂钩
         msg_speak2 <- paste0(input$scp_res,msg_speak)
         updateTextAreaInput(session,'scp_res',label = '消息输出编辑框',value = msg_speak2)
         
      }
      
   })
   
   
   # run_dataTable2('spt_dataTable',head(iris))
   #处理问题列表
   books <- getBooks()
   print(books)
   #领取答案----
   dtedit2(input, output,
           name = 'books',
           thedata = books,
           edit.cols = c('FQues','FAnsw'),
           edit.label.cols = c('问题','答案'),
           input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(FNUMBER = unique(unlist(books$FNUMBER))),
           view.cols = c('FId','FQues','FAnsw'),
           view.captions = c('序号','问题','答案'),
           title.edit = '获取答案',
           label.edit = '获取答案',
           show.update=T,
           show.delete =F,
           show.insert=F,
           show.copy=F,
           callback.update = books.update.callback,
           callback.insert = books.insert.callback,
           callback.delete = books.delete.callback)
   books2 <- getBooks2()
   print(books2)
   dtedit2(input, output,
           name = 'books2',
           thedata = books2,
           edit.cols = c('FQues','FPriorCount'),
           edit.label.cols = c('问题','催单次数'),
           #input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(FNUMBER = unique(unlist(books$FNUMBER))),
           view.cols = c('FId','FQues','FPriorCount'),
           view.captions = c('序号','问题','催单次数'),
           title.edit = '催单',
           label.edit = '催单',
           show.update=T,
           show.delete =F,
           show.insert=F,
           show.copy=F,
           callback.update = books.update.callback2,
           callback.insert = books.insert.callback,
           callback.delete = books.delete.callback)
   
   
   #2TSP------
   tsp_books <- tsp_getBooks()
   tsp_books1 <- tsp_getBooks1()
   tsp_books2 <- tsp_getBooks2()
   tsp_books3A <- tsp_getBooks3A()
   tsp_books3B <- tsp_getBooks3B()
   tsp_books4 <- tsp_getBooks4()
   #print(books)
   dtedit2(input, output,
           name = 'tcp_prior1',
           thedata = tsp_books1,
           edit.cols = c('FQues','FAnsw'),
           edit.label.cols = c('问题','答案'),
           input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(fname = unique(unlist(books$fname))),
           view.cols = c('FId','FPriorCount','FQues','FAnsw'),
           view.captions = c('序号','催单次数','问题','答案'),
           show.insert = F,
           show.copy = F,
           show.delete = F,
           title.edit = '加急处理',
           label.edit = '加急处理',
           callback.update = tsp_books.update.callback1,
           callback.insert = tsp_books.insert.callback1,
           callback.delete = tsp_books.delete.callback1)
   dtedit2(input, output,
           name = 'tcp_prior2',
           thedata = tsp_books2,
           edit.cols = c('FQues','FAnsw'),
           edit.label.cols = c('问题','答案'),
           input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(fname = unique(unlist(books$fname))),
           view.cols = c('FId','FQues','FAnsw'),
           view.captions = c('序号','问题','答案'),
           show.insert = F,
           show.copy = F,
           show.delete = F,
           title.edit = '普通处理',
           label.edit = '普通处理',
           callback.update = tsp_books.update.callback2,
           callback.insert = tsp_books.insert.callback2,
           callback.delete = tsp_books.delete.callback2)
   dtedit2(input, output,
           name = 'tcp_prior3A',
           thedata = tsp_books3A,
           edit.cols = c('FQues','FAnsw'),
           edit.label.cols = c('问题','答案'),
           input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(fname = unique(unlist(books$fname))),
           view.cols = c('FId','FQues','FAnsw'),
           view.captions = c('序号','问题','答案'),
           show.insert = F,
           show.copy = F,
           show.delete = F,
           show.update=T,
           title.edit = '修改窗口',
           label.edit = '修改',
           callback.update = tsp_books.update.callback3A,
           callback.insert = tsp_books.insert.callback3A,
           callback.delete = tsp_books.delete.callback3A)
   dtedit2(input, output,
           name = 'tcp_prior3B',
           thedata = tsp_books3B,
           edit.cols = c('FQues','FAnsw'),
           edit.label.cols = c('问题','答案'),
           input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(fname = unique(unlist(books$fname))),
           view.cols = c('FId','FQues','FAnsw'),
           view.captions = c('序号','问题','答案'),
           show.insert = F,
           show.copy = F,
           show.delete = F,
           show.update=F,
           title.edit = '修改窗口',
           label.edit = '修改',
           callback.update = tsp_books.update.callback3B,
           callback.insert = tsp_books.insert.callback3B,
           callback.delete = tsp_books.delete.callback3B)
   dtedit2(input, output,
           name = 'tcp_prior4',
           thedata = tsp_books4,
           edit.cols = c('FQues','FAnsw'),
           edit.label.cols = c('问题','答案'),
           input.types = c(FAnsw='textAreaInput'),
           #input.choices = list(fname = unique(unlist(books$fname))),
           view.cols = c('FId','FQues','FAnsw'),
           view.captions = c('序号','问题','答案'),
           show.insert = F,
           show.copy = F,
           show.delete = F,
           show.update=F,
           callback.update = tsp_books.update.callback4,
           callback.insert = tsp_books.insert.callback4,
           callback.delete = tsp_books.delete.callback4)
   
   
   #3品牌车型设置
   var_file_cartype <- var_file('file_brandCartype')
   
   
   data_carType <- eventReactive(input$btn_carType,{
      file <- var_file_cartype()
      res <- readCartype(file)
      return(res)
   })
   
   data_carType_db <- eventReactive(input$btn_carType,{
      file <- var_file_cartype()
      res <- readCartype_db(file)
      return(res)
   })
   
   run_dataTable2('pre_carType',data_carType()) 
   #上传服务器
   
   observeEvent(input$upload_carType,{
      upload_data(conn=conn,table_name = 't_md_carType',data=data_carType_db())
      pop_notice('已上传服务器')
      
   }
   )
   
   
   
   #修改车型
   
   carType <- getCarType_md()
   print(carType)
   dtedit2(input, output,
           name = 'editCarType',
           thedata = carType,
           edit.cols = c('FBrandName','FCartypeName','FBusiObj_like','FBusiOjb_same'),
           edit.label.cols = c('品牌','车型','业务对象(近义词)','业务对象(同义词)'),
           input.types = c(FBusiOjb_same='textAreaInput'),
           #input.choices = list(FNUMBER = unique(unlist(books$FNUMBER))),
           view.cols = c('FBrandName','FCartypeName','FBusiObj_like','FBusiOjb_same'),
           view.captions = c('品牌','车型','业务对象(近义词)','业务对象(同义词)'),
           callback.update = carType.update.callback,
           callback.insert = carType.insert.callback,
           callback.delete = carType.delete.callback)
   
   
   #报表处理
      csp_dates <- var_dateRange('um_cspDates')
   db_cspRpt<- eventReactive(input$um_cspPreview,{
      
      dates <-csp_dates()
      startDate <- as.character(dates[1])
      endDate <- as.character(dates[2])
      print(startDate)
      print(endDate)
      res <- getCspRpt(conn,startDate,endDate)
      print(nrow(res))
      return(res)
   })
   
   observeEvent(input$um_cspPreview,{
      
      run_dataTable2('um_cspInfo',db_cspRpt())
      run_download_xlsx('um_cspInfo_dl',db_cspRpt(),'下载智能导购报表.xlsx')
   })
   
   #  
   tsp_dates <- var_dateRange('um_tspDates')
   db_tspRpt<- eventReactive(input$um_tspPreview,{
      
      dates <-tsp_dates()
      startDate <- as.character(dates[1])
      endDate <- as.character(dates[2])
      print(startDate)
      print(endDate)
      res <- getTspRpt(conn,startDate,endDate)
      print(nrow(res))
      return(res)
   })
   
   observeEvent(input$um_tspPreview,{
      
      run_dataTable2('um_tspInfo',db_tspRpt())
      run_download_xlsx('um_tspInfo_dl',db_tspRpt(),'下载内部支持报表.xlsx')
   })
   
   
   

   #系统用户报表
   db_userInfoRpt <- reactive({
      res <- getUserInfoRpt(app_id=app_id)
      return(res)
   })
   
   
   #系统用户报表
  run_dataTable2('um_userInfo',db_userInfoRpt())
   
  #下载用户信息
  run_download_xlsx('um_userInfo_dl',db_userInfoRpt(),'下载用户明细报表.xlsx')
   
  #处理千牛日志上传--------
  files_cl <- var_file('upload_cl_batch');
  
  data_kflog <- eventReactive(input$cl_upload_preview,{
     res <- nrcsrobot::read_kflog2_new(file = files_cl())
     res$FUser <-user_info()$Fuser
     res$FUploadDate <-tsdo::getDate()
     return(res)
  })
  #获取日志时间
  data_kflog_date <- reactive({
     data <- data_kflog()
     res <- data$log_date[1]
     return(res)
  })
  
  data_kflog_cn <- reactive({
     data <-data_kflog()
     print(names(data))
     names(data) <- c('原文','分组','序号','日期时间','日期','时间','对象','内容','品牌方','导购','上传时间')
     return(data)
     
     
  })
  
  observeEvent(input$cl_upload_preview,{
     run_dataTable2('dt_cl_batch',data_kflog_cn())
     #添加标志
     updateTextInput(session=session,inputId = 'cl_status',value='预览完成,请点上传服务器后等待1-3分钟')
  })
  
  #上传服务器
  observeEvent(input$cl_upload_done,{
     

     
     startDate <- data_kflog_date()
     print(startDate)
     FUser <-user_info()$Fuser
     print(FUser)
     is_new <- caaspkg::is_newQianNiu_log(conn = conn,FUser = FUser,FDate = startDate)
     if(is_new){
        tsda::db_writeTable(conn=conn,table_name = 't_kf_log',r_object = data_kflog(),append = T)
        pop_notice(paste0("上传了",nrow(data_kflog()),"条记录"))
        
     }else{
       ncount <- caaspkg::getQN_logCount_byCspName(conn = conn,FUser = FUser,FDate = startDate) 
       pop_notice(paste0("用户",FUser,"已经在",startDate,"上传了",ncount,"条千牛日志！"))
     }
     

     
     updateTextInput(session,'cl_status',value='数据处理已完成...')
     
     
     
  })
  
  #处理千牛报表下载
  qn_dates <- var_dateRange('um_qnDates')
  db_qnRpt<- eventReactive(input$um_qnPreview,{
     
     dates <-qn_dates()
     startDate <- as.character(dates[1])
     endDate <- as.character(dates[2])
     print(startDate)
     print(endDate)
     res <- caaspkg::getQianNiuRpt(conn,startDate,endDate)
     print(nrow(res))
     return(res)
  })
  
  observeEvent(input$um_qnPreview,{
     
     run_dataTable2('um_qnInfo',db_qnRpt())
     run_download_xlsx('um_qnInfo_dl',db_qnRpt(),'下载千牛日志明细报表.xlsx')
  })
  
  #处理千牛汇总报表-----
  qn_dates2 <- var_dateRange('um_qnDates2')
  db_qnRpt2<- eventReactive(input$um_qnPreview2,{
     
     dates <-qn_dates2()
     print('start')
     startDate <- as.character(dates[1])
     endDate <- as.character(dates[2])
     print(startDate)
     print(endDate)
     res <- caaspkg::getQianNiu2Rpt(conn,startDate,endDate)
     print(nrow(res))
     return(res)
  })
  
  observeEvent(input$um_qnPreview2,{
     
     run_dataTable2('um_qnInfo2',db_qnRpt2())
     run_download_xlsx('um_qnInfo_dl2',db_qnRpt2(),'下载千牛日志汇总报表.xlsx')
  })
  
  #处理日志信息
  logQuery_dates <-var_dateRange('logQuery_dates')
  
  data_logQuery <- eventReactive(input$logQuery_preview,{
     dates <-logQuery_dates()
     startDate <- as.character(dates[1])
     endDate <- as.character(dates[2])
     FUser <-user_info()$Fuser
     res <- caaspkg::getQN_log_byCspName(conn=conn,FUser = FUser,FStartDate = startDate,FEndDate = endDate)
     names(res) <-c('导购','日期','记录数')
     return(res)
     
  })
  
  observeEvent(input$logQuery_preview,{
     run_dataTable2('logQuery_dataShow',data = data_logQuery())
     run_download_xlsx('logQuery_dl',data = data_logQuery(),filename = '千牛日志上传历史.xlsx')
   
     
  })
  
})
