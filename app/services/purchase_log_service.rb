class PurchaseLogService

	def initialize user, type_ary=[], options={}
		options.each_pair do |key, value|
     instance_variable_set("@#{key}", value)
   	end
   	raise 'user 缺失' unless @user && @user.is_a?(User)
   	@user_info = user.user_info
   	@type_ary = type_ary
	end


	def create 
		@type_ary.each do |type|
			# undefind method 错误处理？
			send("set_#{type}_params")
			@user_info.purchase_logs.create!(purchase_log_params)
		end
	end

	def set_service_params
		@operation = '服务费'
		@payment_method = '余额支付'
		@detail = ''
		@amount = @appointment.service_cost
		@is_increased = false
	end

	def set_case_params
		@operation = '护理费'
		@payment_method = '余额支付'
		@detail = @appointment.care_type
		@amount = @appointment.care_cost
		@is_increased = false
	end

	def set_credit_params
		@operation = '积分赠送'
		@payment_method = '余额支付'
		@detail = "充值 #{@ping_request.credit}元;赠送 #{@ping_request}元"
		@amount = @ping_request.credit
		@is_increased = true
	end

	def set_pingpp_recharge_params
		@operation = '在线充值'
		@payment_method = 
			I18n.t :"pingpp_channel.#{@ping_request.channel}"
		@detail = ''
		@amount = @ping_request.amount
		@is_increased = true
	end

	def set_offline_recharge_params
		@operation = '线下充值'
		@payment_method = '在线支付'
		@detail = ''
		@amount = 0
		@is_increased = 
	end

	def set_distribution_params
		@operation = '配送'
		@payment_method = '在线支付'
		@detail = ''
		@amount = 0
		@is_increased = false
	end
     
private

	def purchase_log_params
		params = {
			operation: @operation
			payment_method: @payment_method
			detail: @detail
			amount: @amount
			is_increased: @is_increased
		}
		raise '创建参数缺失' unless params.values.include?(nil)
	end



end

PurchaseLogService.new()
