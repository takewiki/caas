# 设置app标题-----

app_title <-'AI汽车导购综合平台V4.8';

#change log for caas
#4.8
#fix the bug
#4.7
#增加日志QA匹配功能
#4.6------
#修改油卡没有发放问题
#完善油卡上传数据日志处理
#完善日志上传功能
#4.5-------
#修复日志打标丢失记录的问题
#增加油卡上传功能
#增加对油卡问题的拟合，人性化回复
#4.4--------
#增加对油卡的日志查询
#4.3-------
# 增加对日志的黑名单处理,通过标记而不是删除的方式进行处理
#4.2-------
# 增加对导购员按天导出日志的支持
#4.1-------
#增加对查询结果的容错机制的处理
#4.0----- 
#增加对相似问的容错机器的处理
#后续针对功能进行改进
#1.增加try-catch机制，让服务进程不容易损坏
#2.增加负载均衡,暂时使用3个服务器
#3.增加对知识库的支持




# store data into rdbe in the rds database
app_id <- 'caas'

conn_kms <- wulair::conn()

tsp_name <- '巴豆'

conn_be <- conn_rds('rdbe')


# 设置3条消息框------
msg <- list(
  list(from = "人力资源部1",
       message= "7月工资表已完成计算"),
  list(from="数据部2",
       message = "HR功能已更新到V2",
       icon = "question",
       time = "13:45"
  ),
  list(from = "技术支持3",
       message = "新的HR数据中台已上线.",
       icon = "life-ring",
       time = "2019-08-26"
  )
)

#设置链接---
conn <- conn_rds('nsic')



#以下为TSP内容-------
tsp_getBooks <- function(table='t_tsp_ques') {
  sql <- sql_gen_select(conn,table = table)
  books <-tsda::sql_select(conn,sql)
  #针对进行格式化处理
  #如果出来新的数据类型，需要添加格式化函数
  #请修改format_to_dtedit  --formatter.R
  fieldList <-sql_fieldInfo(conn,table)
  for (i in 1:ncol(books)){
    type <-fieldList[i,'FTypeName']
    books[,i] <-format_to_dtedit(type)(books[,i])

  }

  return(books)
}
# 定义加急处理
tsp_getBooks1 <- function(table='t_tsp_ques') {
  sql <- sql_gen_select(conn,table = table)
  #添加内容
  sql <- paste0(sql,'  where FPushStatus = 0 and FPriorCount >0
order by FPriorCount desc')
  books <-tsda::sql_select(conn,sql)
  #针对进行格式化处理
  #如果出来新的数据类型，需要添加格式化函数
  #请修改format_to_dtedit  --formatter.R
  fieldList <-sql_fieldInfo(conn,table)
  for (i in 1:ncol(books)){
    type <-fieldList[i,'FTypeName']
    books[,i] <-format_to_dtedit(type)(books[,i])

  }

  return(books)
}

#普通处理------
tsp_getBooks2 <- function(table='t_tsp_ques') {
  sql <- sql_gen_select(conn,table = table)
  #添加内容
  sql <- paste0(sql,'  where FPushStatus = 0 and FPriorCount = 0
')
  books <-tsda::sql_select(conn,sql)
  #针对进行格式化处理
  #如果出来新的数据类型，需要添加格式化函数
  #请修改format_to_dtedit  --formatter.R
  fieldList <-sql_fieldInfo(conn,table)
  for (i in 1:ncol(books)){
    type <-fieldList[i,'FTypeName']
    books[,i] <-format_to_dtedit(type)(books[,i])

  }

  return(books)
}

#今日处理------
tsp_getBooks3A <- function(table='t_tsp_ques') {
  sql <- sql_gen_select(conn,table = table)
  #添加内容,主管已提供答案，但是客服还没有
  sql <- paste0(sql,"  where FPushStatus = 1 and FPullStatus =0   and  FTspDate = '",as.character(Sys.Date()),"'"
  )
  books <-tsda::sql_select(conn,sql)
  #针对进行格式化处理
  #如果出来新的数据类型，需要添加格式化函数
  #请修改format_to_dtedit  --formatter.R
  fieldList <-sql_fieldInfo(conn,table)
  for (i in 1:ncol(books)){
    type <-fieldList[i,'FTypeName']
    books[,i] <-format_to_dtedit(type)(books[,i])

  }

  return(books)
}
tsp_getBooks3B <- function(table='t_tsp_ques') {
  sql <- sql_gen_select(conn,table = table)
  #添加内容,主管已提供答案，但是客服还没有
  sql <- paste0(sql,"  where FPushStatus = 1   and  FTspDate = '",as.character(Sys.Date()),"'"
  )
  books <-tsda::sql_select(conn,sql)
  #针对进行格式化处理
  #如果出来新的数据类型，需要添加格式化函数
  #请修改format_to_dtedit  --formatter.R
  fieldList <-sql_fieldInfo(conn,table)
  for (i in 1:ncol(books)){
    type <-fieldList[i,'FTypeName']
    books[,i] <-format_to_dtedit(type)(books[,i])

  }

  return(books)
}




#全部处理查询------
tsp_getBooks4 <- function(table='t_tsp_ques') {
  sql <- sql_gen_select(conn,table = table)
  #添加内容
  sql <- paste0(sql,"  where FPushStatus = 1 ")
  books <-tsda::sql_select(conn,sql)
  #针对进行格式化处理
  #如果出来新的数据类型，需要添加格式化函数
  #请修改format_to_dtedit  --formatter.R
  fieldList <-sql_fieldInfo(conn,table)
  for (i in 1:ncol(books)){
    type <-fieldList[i,'FTypeName']
    books[,i] <-format_to_dtedit(type)(books[,i])

  }

  return(books)
}




getMax_id <-function(conn,table='t_tsp_ques',id_var='FId'){
  sql <- sql_gen_select(conn,table,id_var)
  #print(sql)
  r <-tsda::sql_select(conn,sql)
  res <- max(as.integer(r[,id_var]))+1
  return(res)
}

##### Callback functions.


tsp_books.insert.callback <- function(data, row ,table='t_tsp_ques',f=tsp_getBooks,id_var='FId') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }

  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}

tsp_books.insert.callback1 <- function(data, row ,table='t_tsp_ques',f=tsp_getBooks1,id_var='FId') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }

  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}
tsp_books.insert.callback2 <- function(data, row ,table='t_tsp_ques',f=tsp_getBooks2,id_var='FId') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }

  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}

tsp_books.insert.callback3A <- function(data, row ,table='t_tsp_ques',f=tsp_getBooks3A,id_var='FId') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }

  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}

tsp_books.insert.callback3B <- function(data, row ,table='t_tsp_ques',f=tsp_getBooks3B,id_var='FId') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }

  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}
tsp_books.insert.callback4 <- function(data, row ,table='t_tsp_ques',f=tsp_getBooks4,id_var='FId') {
  sql_header <- sql_gen_insert(conn,table)
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-nrow(fieldList)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Insert <-fieldList[i,'FFieldName']
    type <-fieldList[i,'FTypeName']
    if(col_Insert == id_var){
      res[i] <-paste0(' ',getMax_id(conn,table,id_var),' ')
    }else{
      res[i] <- format_to_sqlInsert(type)(data[row,col_Insert])
    }

  }
  sql_body <- paste0(res,collapse = ',')
  query <-paste0(sql_header,sql_body,")")

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}


tsp_books.update.callback <- function(data, olddata, row,
                                  table='t_tsp_ques',
                                  f=tsp_getBooks,
                                  edit.cols = c('FQues','FAnsw'),
                                  id_var='FId')
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))


  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_body,sql_tail)

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}

#紧急处理
tsp_books.update.callback1 <- function(data, olddata, row,
                                   table='t_tsp_ques',
                                   f=tsp_getBooks1,
                                   edit.cols = c('FQues','FAnsw'),
                                   id_var='FId')
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))


  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_body,sql_tail)

  print(query) # For debugging
  sql_update(conn, query)

  #处理状态为1及为当天日期
  sql_status <-paste0("update  t_tsp_ques set FPushStatus =1 ,FTspDate ='",as.character(Sys.Date()),"'  where FId  = ",data[row,id_var]," and FPushStatus = 0 ")
  #print(sql_status)
  sql_update(conn,sql_status)
  return(f())
}


tsp_books.update.callback2 <- function(data, olddata, row,
                                   table='t_tsp_ques',
                                   f=tsp_getBooks2,
                                   edit.cols = c('FQues','FAnsw'),
                                   id_var='FId')
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))


  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_body,sql_tail)

  print(query) # For debugging
  sql_update(conn, query)
  #处理状态为1及为当天日期
  sql_status <-paste0("update  t_tsp_ques set FPushStatus =1 ,FTspDate ='",as.character(Sys.Date()),"'  where FId  = ",data[row,id_var]," and FPushStatus = 0 ")
  #print(sql_status)
  sql_update(conn,sql_status)
  return(f())
}

tsp_books.update.callback3A <- function(data, olddata, row,
                                    table='t_tsp_ques',
                                    f=tsp_getBooks3A,
                                    edit.cols = c('FQues','FAnsw'),
                                    id_var='FId')
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))


  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_body,sql_tail)

  print(query) # For debugging
  sql_update(conn, query)
  #更新状态
  sql_status <-paste0("update  t_tsp_ques set  FUpdateStatus = 1   where FId  = ",data[row,id_var]," and FPushStatus = 1 ")
  print(sql_status)
  sql_update(conn,sql_status)
  return(f())
}

tsp_books.update.callback3B <- function(data, olddata, row,
                                    table='t_tsp_ques',
                                    f=tsp_getBooks3B,
                                    edit.cols = c('FQues','FAnsw'),
                                    id_var='FId')
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))


  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_body,sql_tail)

  print(query) # For debugging
  sql_update(conn, query)
  #更新状态
  sql_status <-paste0("update  t_tsp_ques set  FUpdateStatus = 1   where FId  = ",data[row,id_var]," and FPushStatus = 1 ")
  print(sql_status)
  sql_update(conn,sql_status)
  return(f())
}


tsp_books.update.callback4 <- function(data, olddata, row,
                                   table='t_tsp_ques',
                                   f=tsp_getBooks4,
                                   edit.cols = c('FQues','FAnsw'),
                                   id_var='FId')
{
  sql_header <- sql_gen_update(table);
  fieldList <-sql_fieldInfo(conn,table)
  ncount <-length(edit.cols)
  res <- character(ncount)
  for (i in 1:ncount){
    col_Update <-edit.cols[i]
    #col_Insert <-fieldList[fieldList$,'FFieldName']
    type <-fieldList[fieldList$FFieldName == col_Update,'FTypeName']
    res[i] <- paste0(' ',col_Update,' = ',format_to_sqlUpdate(type)(data[row,col_Update]))


  }
  sql_body <- paste0(res,collapse = ',')
  sql_tail <-paste0(' where ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_body,sql_tail)

  print(query) # For debugging
  sql_update(conn, query)
  return(f())
}

tsp_books.delete.callback <- function(data, row ,table ='t_tsp_ques',f=tsp_getBooks,id_var='FId') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)

  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  sql_update(conn, query)
  return(f())
}

tsp_books.delete.callback1 <- function(data, row ,table ='t_tsp_ques',f=tsp_getBooks1,id_var='FId') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)

  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  sql_update(conn, query)
  return(f())
}

tsp_books.delete.callback2 <- function(data, row ,table ='t_tsp_ques',f=tsp_getBooks2,id_var='FId') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)

  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  sql_update(conn, query)
  return(f())
}
tsp_books.delete.callback3A <- function(data, row ,table ='t_tsp_ques',f=tsp_getBooks3A,id_var='FId') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)

  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  sql_update(conn, query)
  return(f())
}


tsp_books.delete.callback3B <- function(data, row ,table ='t_tsp_ques',f=tsp_getBooks3B,id_var='FId') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)

  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  sql_update(conn, query)
  return(f())
}

tsp_books.delete.callback4 <- function(data, row ,table ='t_tsp_ques',f=tsp_getBooks4,id_var='FId') {
  sql_header <- sql_gen_delete(table);
  sql_tail <-paste0('  ',id_var,' = ',data[row,id_var])
  query <- paste0(sql_header,sql_tail)

  #query <- paste0("DELETE FROM  ",table,"  WHERE id = ", data[row,]$id)
  print(query)
  sql_update(conn, query)
  return(f())
}




#以下为系统管理报表









