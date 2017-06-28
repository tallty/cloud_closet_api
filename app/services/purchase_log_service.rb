class PurchaseLogService
	# 真实交易成功完成 而后续操作报错 应该有报警。？！
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
				next if purchase_log_params[:amount] == 0
				purchase_log_ary << @user_info.purchase_logs.create!(purchase_log_params)
			end
		
			# 确认全部创建后 
			purchase_log_ary.each do |purchase_log|
				# 操作 用户 余额
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
		purchase_log_ary
	end

private
		# -------  消费  ------- #

		# def set_service_cost_params # appointment
		# 	@operation = '服务费'
		# 	@payment_method = '余额支付'
		# 	@detail = ''
		# 	@amount = @appointment.service_cost
		# 	@is_increased = false
		# end

		# def set_case_cost_params # appointment
		# 	@operation = '护理费'
		# 	@payment_method = '余额支付'
		# 	@detail = @appointment.care_type
		# 	@amount = @appointment.care_cost
		# 	@is_increased = false
		# end

		# def set_montly_rent_params # info
		# 	@operation = "#{Time.zone.now.month}月租金"
		# 	@payment_method = '余额支付'
		# 	@detail = @info[:detail]
		# 	@amount = @info[:amount]
		# 	@is_increased = false
		# 	@can_arrears = true
		# end

		# def set_new_chest_rent_params # appointment
		# 	@operation = '新赠衣柜的租金'
		# 	@payment_method = '余额支付'
		# 	@amount, @detail = RentService.new(@user).appt_new_chest_rent(@appointment)
		# 	@is_increased = false
		# 	@can_arrears = true
		# end

		def set_appt_paid_successfully_params
			@operation = '入库订单支付成功'
			@payment_method = '余额支付'
			@amount = @appointment.price 
			@detail = 
				"衣柜总租金： #{@appointment.rent_charge} 元，
				服务费：#{@appointment.service_cost} 元,
				护理费：#{@appointment.care_cost} 元，
				真空袋等其他费用：#{@appointment.other_price} 元，
				总计：#{@appointment.price} 元。"
			@is_increased = false
			@can_arrears = false
		end

		def set_delivery_order_params
			@operation = '衣服配送'
			@payment_method = '在线支付'
			@detail = "配送费： #{@delivery_order.delivery_cost} 元，服务费：#{@delivery_order.service_cost} 元"
			@amount = @delivery_order.amount
			@is_increased = false
		end

		def set_service_order_params # 服务订单
			@operation = '服务收费'
			@payment_method = '余额支付'
			@amount = @service_order.price 
			@detail = @service_order.operation == '衣橱续租' ?
			
				"衣橱续租，#{@service_order.remark}，
				消费租金：#{@service_order.rent} 元。" :
				
				"衣柜总租金： #{@service_order.rent} 元，
				服务费：#{@service_order.service_cost} 元，
				护理费：#{@service_order.care_cost} 元，
				总计：#{@service_order.price} 元"

			@is_increased = false
			@can_arrears = false
		end

	 # -------  充值  ------- #

		def set_pingpp_recharge_params # ping_request
			@operation = '在线充值'
			@payment_method = '微信支付'
				I18n.t :"pingpp_channel.#{@ping_request.channel}"
			@detail = ''
			@amount = @ping_request.amount * 0.01
			@actual_amount = @amount
			@credit = @amount
			@is_increased = true
		end

		def set_offline_recharge_params # offline_recharge
			@operation = '线下充值'
			@payment_method = '线下充值' || ''
			@detail = 
				"为您充值的工作人员电话: #{@offline_recharge.worker_phone}"
			@amount = @offline_recharge.amount
			@actual_amount = @amount
			@credit = @amount
			@is_increased = true
		end

		def set_credit_params # ping_request/offline_recharge
			@ping_request.amount *= 0.01 if @ping_request
			object = @ping_request || @offline_recharge
			@operation = "充值 #{object.amount}元, 赠送 #{object.credit}元"
			@payment_method = '充值返现'
			@detail = 
				"充值 #{object.amount}元 ; " + 
				"赠送 #{object.credit}元"
			@amount = object.credit
			@credit = @amount
			@is_increased = true
		end

		# ----------------------------------------------------

		def purchase_log_params
			params = {
				operation: @operation,
				payment_method: @payment_method,
				detail: @detail,
				amount: @amount,
				credit: @credit || 0, # 积分 可不存在 
				can_arrears: @can_arrears,
				is_increased: @is_increased,
				actual_amount: @actual_amount
			}
			missing_val = params.map { |key, val| 
					val ? next : key 
				}.reject{ |i| 
					i.nil? || i.in?([:is_increased, :can_arrears, :actual_amount]) # 可为true or false
				}
			raise "创建参数缺失 #{missing_val}" if missing_val.any?
			params
		end

		def change_balance purchase_log
			change = purchase_log.is_increased ? :+ : :-
			# 增加相应余额
			purchase_log.balance = 
				@user_info.balance = 
					[ @user_info.balance, purchase_log.amount || 0 ].reduce(change)
			raise '余额不足，扣费失败' if purchase_log.balance < 0 && purchase_log.can_arrears.!
			# 增加相应积分
			VipService.new(@user_info).credit_add(purchase_log.credit) unless purchase_log.credit == 0
			# 真实充值金额， 可供开取发票
			@user_info.recharge_amount = [ @user_info.recharge_amount,( purchase_log.actual_amount || 0 )].reduce(change)
			@user_info.save!
			purchase_log.save
		end
	end


