bb <-tsui::readUserFile(file = "caas_users -v2.xlsx")
cc <- tsui::userRight_upload(app_id = 'caas',data = bb)


dd <-userInfo_upload(data = bb,app_id = 'caas')

