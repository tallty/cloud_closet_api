require "pingpp"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击管理平台右上角公司名称->开发信息-> Secret Key
API_KEY = "sk_live_TCyDmTb9Km9Kav1iP4jvHeD8"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击你创建的应用->应用首页->应用 ID(App ID)
APP_ID = "app_TCGezLWzLe1K5Oar"
# 设置 API key
Pingpp.api_key = API_KEY
# 设置你的私钥路径，用于请求的签名
# 私钥生成 https://help.pingxx.com/article/123161/
Pingpp.private_key_path = File.dirname(__FILE__) + '/../../your_rsa_private_key.pem'

Pingpp.pub_key_path =  File.dirname(__FILE__) + '/../../pingpp_rsa_public_key.pem'
