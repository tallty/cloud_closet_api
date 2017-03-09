class WechatMessageService

	def initialize user
		@openid = user.try(:openid)
		# @openid = 'olclvwHtOBENZ-rLA2NxsBCVZky0'
		raise '用户openid 为空' if @openid.blank?
		@template = {}
	end

	def appt_state_msg appt
    appt_state_remark = {
			committed: '工作人员即将与您联系确认订单。', 
			accepted: '请您留意上门时间，作好合理安排。', 
			unpaid: '您的订单已生成，请尽快完成付款', 
			paid: '如有疑问，敬请咨询客服热线：15800634815',
			storing: '如有疑问，敬请咨询客服热线：15800634815', 
			stored: '如有疑问，敬请咨询客服热线：15800634815', 
			canceled: ''
		}
    @template = Appt_state_msg
    # 商家名称
    @template[:date][:keyword1] = '乐存好衣'
    # 商家电话
    @template[:date][:keyword2] = '15800634815'
    # 订单号
    @template[:date][:keyword3] = appt.seq
    # 状态
    @template[:date][:keyword4] = appt.state
    # 总价
    @template[:date][:keyword5] = appt.price == 0 ? "上门评估" : appt.price
    # 提示
    @template[:date][:remark] = appt_state_remark[ appt.aasm_state.to_sym ]
    # 点击触发地址 默认为我的订单页面 'http://closet.tallty.com/orders'
    @template[:url] = 'http://closet.tallty.com/MyCloset' if appt.aasm_state == 'stored'
    
    send_msg
  end

  def send_msg
  	response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
      { openid: @openid, template: @template}
    puts response.body
  end


  Appt_state_msg = {
      template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
      url: "http://closet.tallty.com/orders",
      topcolor: "#FF0000",
      data: {
        first: {
          color: "#0A0A0A"
        },
        keyword1: {
          color: "#757575"
        },
        keyword2: 
        {
          color: "#757575"
        },
        keyword3: {
          color: "#757575"
        },
        keyword4: {
          color: "#757575"
        },
        keyword5: {
          color: "#757575"
        },
        remark: {
          color: "#173177"
        }
      }
    }


end