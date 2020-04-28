# 设置app标题-----

app_title <-'AI汽车导购综合平台V1.1';

# store data into rdbe in the rds database
app_id <- 'caas'

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






