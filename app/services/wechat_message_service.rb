class WechatMessageService
  # e.g. WechatMessageService.new(user).state_msg(@appt)

	def initialize user
    @user = user
		@openid = user.try(:openid)
		raise '用户openid 为空' if @openid.blank?
		@template = {}
    @merchant_phone = '15800634815'
    @merchant_name = '乐存好衣'
	end

  def send_msg type, arg
    p "---wechat--- set_#{type}--------" 
    send( "set_#{type}", arg )
    unless Rails.env == 'test'
      response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
        { openid: @openid, template: @template }
      puts response.body
      # 用户消息中心消息
      UserMsgService.new(@user, 'from_wechat_msg', wechat_msg: self)
    end
  end

  private
    # ---- 订单状态改变 微信通知 --- #

  	def set_appt_state_msg appt
      @title = '亲，您的预约订单状态变更，请注意查看'
      @seq = appt.seq
      @state = appt.state
      @amount = appt.price == 0 ? "上门评估" : appt.price
      @remark = appt_remark_list[appt.aasm_state.to_sym]
      
      @url = appt.stored? ? 
              'http://closet.tallty.com/MyCloset' :
              'http://closet.tallty.com/orders'
      @template = state_template
    end

    # ---- 配送订单 状态改变（被取消） 微信通知 --- #

    def set_delivery_order_state_msg delivery_order
      @title = delivery_order_title_list[delivery_order.aasm_state.to_sym] || '亲，您的配送订单状态变更，请注意查看'
      @seq = delivery_order.seq
      @state = delivery_order.state
      @amount = delivery_order.amount
      @remark = "如有疑问，敬请咨询客服热线：#{@merchant_phone}"
      @url = 'http://closet.tallty.com/orders'
      @template = state_template
    end

    # ---- 充值 微信通知 --- #

    def set_recharge_msg purchase_log
      @title = "#{purchase_log.operation}"
      @amount = purchase_log.amount
      @time = purchase_log.created_at.strftime("%Y-%m-%d %H:%M:%S")
      @remark = "当前余额: #{purchase_log.balance} 元\n" + 
                  "#{purchase_log.detail}\n\n" +
                  "如有疑问，敬请咨询：#{@merchant_phone}." 
      
      @url = 'http://closet.tallty.com/user'
      @template = recharge_template
    end

    # ---- 消费 微信通知 --- #

    def set_consume_msg purchase_log
      @title = '您有一笔最新消费信息'
      @amount = purchase_log.amount
      @operation = purchase_log.operation
      @balance_now = purchase_log.balance
      @time = purchase_log.created_at.strftime("%Y-%m-%d %H:%M:%S")
      @remark = '谢谢您的支持'
   p '-----url -----'   
   p  @url = "http://closet.tallty.com/bills/#{purchase_log.id}"
      @template = consume_template
    end

    # ---- 余额不足 微信通知 --- #

    def set_urgent_insufficient_balance_msg info
      @title = '亲，您当前账户余额不足本月的租金啦!'
      @account = info[:phone]
      @balance = info[:balance]
      @remark = "支付本月租金还需 #{info[:arrears]} 元"

      @url = 'http://closet.tallty.com/user'
      @template = insufficient_balance_template
    end

    def set_insufficient_balance_msg info
      @title = '亲，您当前账户余额不足下个月的租金啦!'
      @account = info[:phone]
      @balance = info[:balance]
      @remark = "下个月租金为 #{info[:rent]} 元\n" +
                "为保证下个月成功扣费，请充值 #{info[:arrears]} 元"

      @url = 'http://closet.tallty.com/user'
      @template = insufficient_balance_template
    end

    # ---- 订单状态改变 提示不同备注 --- #

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

    def delivery_order_title_list
      {
        unpaid: '亲，您的配送订单已创建',
        paid: "亲，您的配送订单已完成付款。\n我们将准时为您送出 ~",
        delivering: "亲，您的衣服已发出。\n马上就能见到您啦 ~",
        canceled: "亲，您的配送订单已取消。\n款项已退还，衣服已经回到您的衣橱里啦 ~",
        finished: "亲，衣服已到家。\n再会 ~"
      }
    end
    
    # ---- 微信模板 --- #

    def state_template 
     template = {
        template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
        url: @url,
        topcolor: "#FF0000",
        data: {
          first: {
            color: "#0A0A0A",
            value: @title
          },
          keyword1: {
            color: "#757575",
            value: @merchant_nameΩ
          },
          keyword2: 
          {
            color: "#757575",
            value: @merchant_phone
          },
          keyword3: {
            color: "#757575",
            value: @seq
          },
          keyword4: {
            color: "#757575",
            value: @state
          },
          keyword5: {
            color: "#757575",
            value: @amount
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
        template_id: "q-PZND2iTTkNRAEwcWGsK9ETN6_ryMfvn2Q0eSs11rA",
        url: @url, 
        topcolor: "#FF0000",

        data: {
          first: {
            value: @title,
            color: "#0A0A0A"
          },
          # 本次充值
          keyword1: {
            value: @amount,
            color: "#757575"
          },
          # 充值时间
          keyword2: {
            value: @time,
            color: "#757575"
          },
          remark: {
            value: @remark,
            color: "#173177"
          }
        }
      }

    end

    def consume_template
       template = {
        template_id: "hFCXLN4imU5Zh7ZgjjmaHyAxhXotxHu4MwEeJCYAIjk",
        url: @url, #{}"http://closet.tallty.com/user",
        topcolor: "#FF0000",

        data: {
          first: {
            value: @title,
            color: "#0A0A0A"
          },
          # 消费金额
          keyword1: {
            value: @amount,
            color: "#757575"
          },
          # 消费类型
          keyword2: {
            value: @operation,
            color: "#757575"
          },
          # 充值门店
          keyword3: {
            value: @merchant_name,
            color: "#757575"
          },
          # 卡内余额
          keyword4: {
            value: @balance_now,
            color: "#757575"
          },
          # 消费时间
          keyword5: {
            value: @time,
            color: "#757575"
          },
          remark: {
            value: @remark,
            color: "#173177"
          }
        }
      }
    end

    def insufficient_balance_template
      template = {
        template_id: "6uuBWTV5mf9FzmGsCEH0Ddtt13gxsQn1RiUkb4Fk9ok",
        url: @usl, 
        topcolor: "#FF0000",
        data: {
          first: {
            value: @title,
            color: "#0A0A0A"
          },
          # 账号
          keyword1: {
            value: @account,
            color: "#757575"
          },
          # 当前余额
          keyword2: {
            value: @balance,
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