class SmsService
	@worker_list = [
		'15800634815',
		'13605028695',
		]

	def initialize to_whom
		@phone_list = SmsService.instance_variable_get("@#{to_whom}_list")
	end
	# 【乐存好衣】有新的用户预约，订单号: #seq#，用户名：#name#，联系电话： #phone#。
	def new_appt appt
		@tpl_id = 1727876
    @sms_hash = {
    	seq: appt.seq,
    	name: appt.name,
    	phone: appt.phone,
    }
    send_msg
	end
	# 【乐存好衣】一位用户余额不足，无法进行#month#扣费。
	# 用户名：#name#，联系电话：#phone#，当前余额：#balance#
	# 应缴#month#月租#rent#元
	def insufficient_blannce_remind info
		@tpl_id = 1735962
    @sms_hash = info
    send_msg
	end

	def send_msg
		result_ary = []
		@phone_list.each do |phone|
			ChinaSMS.use :yunpian, password: "255281473668c1ef1fc752b71ce575d8"
	    result_ary << (ChinaSMS.to phone, @sms_hash, {tpl_id: @tpl_id})
    end
    result_ary
	end

end