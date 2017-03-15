class SmsService
	@worker_list = [
		'13605028695',
		'15800634815',
		]

	def initialize to_whom
		@phone_list = SmsService.instance_variable_get("@#{to_whom}_list")
	end
	# 【乐存好衣】有新的用户预约，订单号: #seq#，用户名：#name#，联系电话： #phone#。
	def new_appt appt
		tpl_id = 1727876
    sms_hash = {
    	seq: appt.seq,
    	name: appt.name,
    	phone: appt.phone,
    }
    ChinaSMS.use :yunpian, password: "255281473668c1ef1fc752b71ce575d8"
    result = ChinaSMS.to @phone_list, sms_hash, {tpl_id: tpl_id}
	end
	# 【乐存好衣】一位用户余额不足，无法进行#month#扣费。
	# 用户名：#name#，联系电话：#phone#，当前余额：#balance#
	# 应缴#month#月租#rent#元
	def insufficient_blannce_remind info
		tpl_id = 1735962
    sms_hash = info
    ChinaSMS.use :yunpian, password: "255281473668c1ef1fc752b71ce575d8"
    result = ChinaSMS.to @phone_list, sms_hash, {tpl_id: tpl_id}
	end

end