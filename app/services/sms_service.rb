class SmsService
	@worker_list = [
		'13605028695',
		'15800634815',
		]

	def initialize type
		@phone_list = SmsService.instance_variable_get("@#{type}_list")
	end

	def new_appt appt
		tpl_id = 1727876
    sms_hash = {
    	seq: appt.seq,
    	name: appt.name,
    	phone: appt.phone,
    }
    ChinaSMS.use :yunpian, password: "255281473668c1ef1fc752b71ce575d8"
    result = ChinaSMS.to @phone_list, sms_hash, {tpl_id: tpl_id}
    logger.info result
	end

end