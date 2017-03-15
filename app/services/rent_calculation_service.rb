class RentCalculationService
	# 租金计算相关

	def initialize user
		@user = user
	end

	def appt_new_chest_rent appt
		ratio = (Time.now.day.to_f / Time.days_in_month(Time.now.month)).round(2)
		rent = appt.groups.map { |group| group.price * ratio }.reduce(:+) || 0
		purchase_log_detail =  appt.groups.map { |group|
	    	 "#{group.title},#{group.count}个," + 
	    	 "#{group.price.to_s + '元/月'}," +
	    	 "本次收费: #{group.price * ratio}元" 
    	 }.join(";")
  	 [ rent, purchase_log_detail ]
	end




	def monthly_rent
		rent = 0
		@user.valuation_chests.each do |val_chest|
			# val_chest.exhibition_chests
		end

		# 通知用户
		WechatMessageService.new(@user).set_insufficient_balance_msg()
		# 通知工作人员
		
	end

	class << self 
		def method_name
			
		end
		
	end

end