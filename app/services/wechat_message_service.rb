# class WechatMessageService

# 	def in
		
# 	end


# 	def aaa
#     openid = 'olclvwHtOBENZ-rLA2NxsBCVZky0'
#     return if openid.blank?
#     template = {
#       template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
#       url: "http://closet.tallty.com/orders",
#       topcolor: "#FF0000",
#       data: {
#         first: {
#           value: "亲，您的预约订单状态变更，请注意查看。",
#           color: "#0A0A0A"
#         },
#         keyword1: {
#           value: "乐存好衣",
#           color: "#CCCCCC"
#         },
#         # keyword2: {
#         #   value: 111,#商家电话？？？？！！！！
#         #   color: "#CCCCCC"
#         # },
#         keyword3: {
#           value: 111,
#           color: "#CCCCCC"
#         },
#         keyword4: {
#           value: 111,
#           color: "#CCCCCC"
#         },
#         keyword5: {
#           value: "上门评估",
#           color: "#CCCCCC"
#         },
#         remark: {
#           value: "请您留意上门时间，合理安排好您的时间",
#           color: "#173177"
#         }
#       }
#     }
#     # if state == 'stored'
#     #   template[:url] = 'http://closet.tallty.com/MyCloset' 
#     #   template[:data][:keyword3] = nil
#     #   template[:data][:remark] = nil
#     # end
    
#     response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
#       { openid: openid, template: template}
#     puts response.body
#   end


# end