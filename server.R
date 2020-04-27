

#shinyserver start point----
 shinyServer(function(input, output,session) {
    #读取用户列表
    user_base <- getUsers(conn,app_id)
   
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
     actionButton('currentUser',label =user_info()$Fuser,icon = icon('user') )
     
   })
   
   #修改密码
   observeEvent(input$currentUser,{
      req(credentials()$user_auth)
      
      showModal(modalDialog(title = paste0("修改",user_info()$Fname,"用户密码"),
                         
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
   
   user_data <- reactive({
     
     req(credentials()$user_auth)
     
     if (user_info()$Fpermissions == "admin") {
       dplyr::starwars[,1:10]
     } else if (user_info()$Fpermissions == "standard") {
       dplyr::storms[,1:11]
     }
     
   })
   
   
   output$testUI <- renderUI({
     req(credentials()$user_auth)
     
     print(user_info())
     
     fluidRow(
       column(
         width = 12,
         tags$h2(glue("Your permission level is: {user_info()$permissions}. 
                     Your data is: {ifelse(user_info()$permissions == 'admin', 'Starwars', 'Storms')}.")),
         box(width = NULL, status = "primary",
             title = ifelse(user_info()$Fpermissions == 'admin', "Starwars Data", "Storms Data"),
             DT::renderDT(user_data(), options = list(scrollX = TRUE))
         )
       )
     )
   })
   
   
   
   
  
})
