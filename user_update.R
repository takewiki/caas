bb <-tsui::readUserFile(file = "caas_users -v4.xlsx")
cc <- tsui::userRight_upload(app_id = 'caas',data = bb)


dd <-tsui::userInfo_upload(data = bb,app_id = 'caas')

