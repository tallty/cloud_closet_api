class WechatMessageService

  # e.g. WechatMessageService.new(user).appt_state_msg(appt)
	def initialize user
		@openid = user.try(:openid)
		# @openid = 'olclvwHtOBENZ-rLA2NxsBCVZky0'
		raise '用户openid 为空' if @openid.blank?
		@template = {}
    @merchant_phone = '15800634815'
    @merchant_name = '乐存好衣'
	end

	def appt_state_msg appt
    # @merchant_name = '乐存好衣'
    # @merchant_phone = '15800634815'
    @appt_seq = appt.seq
    @appt_state = appt.state
    @appt_amount = appt.price == 0 ? "上门评估" : appt.price
    @remark = appt_remark_list[ appt.aasm_state.to_sym ]
    # 点击触发地址 默认为我的订单页面 'http://closet.tallty.com/orders'
    @url = appt.stored? ? 
            'http://closet.tallty.com/MyCloset' :
            'http://closet.tallty.com/orders'
    
    @template = appt_state_template
    send_msg
  end

  def recharge_msg ping_request
    @amount = ping_request
    @credit = 
    @balance_now =
    @remark = "如有疑问，敬请咨询：#{@merchant_phone}." 

    @template = @recharge_template
    send_msg
  end

  def consume_msg
    
  end

  def send_msg
  	response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
      { openid: @openid, template: @template}
    puts response.body
  end


   def appt_remark_list
    {
      committed: '工作人员即将与您联系确认订单。', 
      accepted: '请您留意上门时间，作好合理安排。', 
      unpaid: '您的订单已生成，请尽快完成付款', 
      paid: "如有疑问，敬请咨询客服热线：#{@merchant_phone}",
      storing: "如有疑问，敬请咨询客服热线：#{@merchant_phone}", 
      stored: "如有疑问，敬请咨询客服热线：#{@merchant_phone}", 
      canceled: ''
    }
  end
    
  def appt_state_template 
   template = {
      template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
      url: "http://closet.tallty.com/orders",
      topcolor: "#FF0000",
      data: {
        first: {
          color: "#0A0A0A",
          value: "亲，您的预约订单状态变更，请注意查看。"
        },
        keyword1: {
          color: "#757575",
          value: @merchant_name
        },
        keyword2: 
        {
          color: "#757575",
          value: @merchant_phone
        },
        keyword3: {
          color: "#757575",
          value: @appt_seq
        },
        keyword4: {
          color: "#757575",
          value: @appt_state
        },
        keyword5: {
          color: "#757575",
          value: @appt_amount
        },
        remark: {
          color: "#173177",
          value: @remark
        }
      }
    }
  end

  def recharge_template
     template = {
      template_id: "EJGMPFNSkgMee7o50EH0D1eOM3iawiNwjaSteThxex0",
      url: "http://closet.tallty.com/user",
      topcolor: "#FF0000",

      data: {
        first: {
          value: "充值成功",
          color: "#0A0A0A"
        },
        keyword1: {
          value: @amount,
          color: "#757575"
        },
        keyword2: {
          value: @credit,
          color: "#757575"
        },#赠送金额
        keyword3: {
          value: "#{@merchant_name}",
          color: "#757575"
        },#充值门店
        keyword4: {
          value: @balance_now,
          color: "#757575"
        },
        remark: {
          value: @remark,
          color: "#173177"
        }
      }
    }
  end
end