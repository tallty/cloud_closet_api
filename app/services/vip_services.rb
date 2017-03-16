class VipServices

	def initialize user_info
		@user_info = user_info
		@credit = @user_info.credit
		@vip_list = VipLevel.all
		@vip_exp_ary = @vip_list.collect(&:exp)
	end

	def vip_in_user_info 
		index = @vip_exp_ary.map{ |exp| exp < @credit }.index(false) - 1
		level_now = @vip_list[ index ] 
		level_next = @vip_list[ index + 1 ] 
		{
      level_now: level_now.name, 
      level_next: level_next.name, 
      credit_total: @credit,
      exp_now: @credit - level_now.exp,
      need_exp: level_next.exp - level_now.exp
    }
	end

	# def get_user_vip_level
	# 	user_vip = @vip_list.[] @vip_exp_ary.map{ |exp| exp < @credit }.index(false) - 1
	# end

end