class PurchaseLogService

	# PurchaseLogService.new(user, ['service_cost'], { appointment: @appt })
	def initialize user, type_ary=[], options={}
		options.each_pair do |key, value|
     instance_variable_set("@#{key}", value)
   	end
   	raise 'user 缺失' unless (@user = user) && @user.is_a?(User)
   	@user_info = user.user_info
   	@type_ary = type_ary
	end


	def create 
		purchase_log_ary = []
		ActiveRecord::Base.transaction do
			@type_ary.each do |type|
				# undefind method 错误处理？
				send("set_#{type}_params")
				p '----- purchase_log_params params ----'
				p purchase_log_params
				purchase_log_ary << @user_info.purchase_logs.create!(purchase_log_params)
			end
		
			p ' ----  purchase_log_ary ----'
			p purchase_log_ary
			# 确认全部创建后 
			purchase_log_ary.each do |purchase_log|
				# 操作用户余额
				change_balance(purchase_log)
				# 发送 充值/消费 微信消息
				WechatMessageService.new(@user).send_msg(
					purchase_log.is_increased ? 
						'recharge_msg': 
						'consume_msg', 
					purchase_log
					)
			end
		end
	end

	# -------  消费  ------- #

	def set_service_cost_params # appointment
		@operation = '服务费'
		@payment_method = '余额支付'
		@detail = ''
		@amount = @appointment.service_cost
		@is_increased = false
	end

	def set_case_cost_params # appointment
		@operation = '护理费'
		@payment_method = '余额支付'
		@detail = @appointment.care_type
		@amount = @appointment.care_cost
		@is_increased = false
	end

	def set_montly_rent_params 
		@operation = '每月租金'
		@payment_method = '余额支付'
		@detail = @appointment.care_type
		@amount = @appointment.care_cost






		@is_increased = false
	end

	def set_new_chest_rent_params # appointment
		@operation = '新赠衣柜的本月租金'
		@payment_method = '余额支付'
		@detail = @appointment.groups.map { |group|
	    	 "#{group.title},#{group.count}个," + 
	    	 "#{group.price.to_s + '元/月'}," +
	    	 "本次收费: #{group.price * _ratio}元" 
    	 }.join(";")
		@amount = RentCalculationService.new(@user).appt_new_chest_rent(@appointment)
		@is_increased = false
	end

	def set_distribution_params
		@operation = '配送'
		@payment_method = '在线支付'
		@detail = ''
		@amount = 0
		@is_increased = false
	end

 # -------  充值  ------- #

	def set_pingpp_recharge_params # ping_request
		@operation = '在线充值'
		@payment_method = '微信支付'
			I18n.t :"pingpp_channel.#{@ping_request.channel}"
		@detail = ''
		p '===amount==='
		p @amount = @ping_request.amount
		@actual_amount = @amount
		@is_increased = true
	end

	def set_offline_recharge_params # offline_recharge
		@operation = '线下充值'
		@payment_method = '线下充值' || ''
		@detail = 
			"为您充值的工作人员电话: #{@offline_recharge.worker_phone}"
		@amount = @offline_recharge.amount
		@actual_amount = @amount
		@is_increased = true
	end

	def set_credit_params
		@operation = '赠送积分变现为余额'
		@payment_method = '余额支付'
		@detail = 
			"充值 #{@ping_request.amount}元 ;" + 
			"赠送 #{@ping_request.credit}元"
		@amount = @ping_request.credit
		@credit = @amount
		@is_increased = true
	end
     
private

	def purchase_log_params
		params = {
			operation: @operation,
			payment_method: @payment_method,
			detail: @detail,
			amount: @amount,
			is_increased: @is_increased
		}
		missing_val = params.map {|key, val| val ? next : key }.reject{|i| i.nil?}
		raise "创建参数缺失 #{missing_val}" if missing_val.any?
		params
	end

	def change_balance purchase_log
		change = purchase_log.is_increased ? '+' : '-'
		purchase_log.balance = @user_info.balance = @user_info.balance.send(change, purchase_log.amount)# || 0)
		@user_info.credit = @user_info.credit.send(change, purchase_log.credit || 0)
		@user_info.recharge_amount = @user_info.recharge_amount.send(change, purchase_log.actual_amount || 0)
		@user_info.save!
		purchase_log.save
	end
end


