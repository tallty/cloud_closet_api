class VipService

	def initialize user_info
		@user_info = user_info
		@credit = @user_info.credit
		@vip_list = VipLevel.all
		# 去掉 第一位 0 
		@vip_exp_ary = @vip_list.collect(&:exp)[1..-1]
	end

	def vip_in_user_info credit_now=@credit
		return nil unless @vip_exp_ary
		index = @vip_exp_ary.bsearch_index{ |x| x > credit_now } || @vip_exp_ary.count
		level_now = @vip_list[ index ]
		level_next = @vip_list[ index + 1 ] || @vip_list.last
		{
      level_now: level_now.name, 
      level_next: level_next&.name, 
      credit_total: credit_now,
      exp_now: credit_now - level_now.exp,
      need_exp: level_next.exp - level_now.exp
    }
	end

	def credit_add credit
		@user_info.credit += credit || 0
		raise '积分增加失败' unless @user_info.save
		level_up?
	end

	def level_up?
		info_after_adding = vip_in_user_info(@user_info.credit)
		UserMsgService.new(
			@user_info.user, 
			'vip_level_up', 
			info_after_adding: info_after_adding
			) unless vip_in_user_info[:level_now] == info_after_adding[:level_now]
	end
	# def get_user_vip_level
	# 	user_vip = @vip_list.[] @vip_exp_ary.map{ |exp| exp < @credit }.index(false) - 1
	# end

end