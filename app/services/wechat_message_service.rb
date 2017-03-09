class WechatMessageService

	def initialize user
		@openid = user.try(:openid)
		# @openid = 'olclvwHtOBENZ-rLA2NxsBCVZky0'
		raise '用户openid 为空' if openid.blank?
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

    template = {
      template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
      url: "http://closet.tallty.com/orders",
      topcolor: "#FF0000",
      data: {
        first: {
          value: "亲，您的预约订单状态变更，请注意查看。",
          color: "#0A0A0A"
        },
        keyword1: {
          value: "乐存好衣",
          color: "#757575"
        },
        keyword2: 
        {
          value: "15800634815",
          color: "#757575"
        },
        keyword3: {
          value: appt.seq,
          color: "#757575"
        },
        keyword4: {
          value: appt.state,
          color: "#757575"
        },
        keyword5: {
          value: "#{appt.price == 0 ? "上门评估" : appt.price}",
          color: "#757575"
        },
        remark: {
          value: appt_state_remark[ appt.aasm_state.to_sym ],
          color: "#173177"
        }
      }
    }
    template[:url] = 'http://closet.tallty.com/MyCloset' if appt.aasm_state == 'stored'
    
    send_msg
  end

  def send_msg
  	response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
      { openid: @openid, template: @template}
    puts response.body
  end

end