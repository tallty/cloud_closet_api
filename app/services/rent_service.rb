class RentService
	# 租金计算相关

	def initialize user
		@user = user
    @user_info = @user.info
	end

	def appt_new_chest_rent appt
		ratio = (Time.now.day.to_f / Time.days_in_month(Time.now.month)).round(2)
		
    rent = appt.groups.map { |group| 
       group.price * ratio 
      }.reduce(:+) || 0

		purchase_log_detail =  appt.groups.map { |group|
	    	 "#{group.title},#{group.count}个," + 
	    	 "#{group.price.to_s + '元/月'}," +
	    	 "本次收费: #{group.price * ratio}元" 
    	 }.join(";")

  	[ rent, purchase_log_detail ]
	end

  # 每月1号收取
  def deducte_monthly_rent
    @monthly_rent = get_monthly_rent

    @user_info.balance -= @monthly_rent
    @user_info.save!

    # 不足本月 紧急提醒
    insufficient_blannce_remind(is_this_month: true) if @user.balance < 0 
    # 不足下个月 提醒
    insufficient_blannce_remind if @user.balance < rent

  end

  def get_monthly_rent 
    rent = 0
    @user.valuation_chests.each do |val_chest|
      price = val_chest.price
      if price.exhibition_units.count == 1 &&  # 仅有一个显示单位柜
          price.exhibition_units.first.need_join && # 显示单位柜 衣服合并显示
          val_chest.exhibition_chests.collect(&:garments).blank? # 无衣服
        # 释放该可自动释放衣柜 （单件礼服）
        val_chest.soft_delete！
      end
      rent += val_chest.price if val_chest.exhibition_chests.online.any?
    end 
    rent
  end

  # 如果本月余额不足 将发送两条通知
	def insufficient_blannce_remind options={}
    arrears = 
      options[:is_this_month] ? 
        @user_info.balance.abs : 
        ( @user_info.balance - @monthly_rent ).abs

    msg_type = 
      (options[:is_this_month] ? 
        'urgent_insufficient_balance_msg' : 
        'insufficient_balance_msg'
    info = {
      phone: @user.phone,
      name: @user_info.name,
      balance: @user_info.balance,
      rent: @monthly_rent,
      arrears: arrears,
    }
		# 通知用户
		WechatMessageService.new(@user).send_msg(
			msg_type, info
			)
		# 通知工作人员
     
	end



	class << self 
    # 每月1号 收取所有用户租金
		def deducte_all_user_rent
			User.all.each do |user|
        RentService.new(user).deducte_monthly_rent
      end
		end
		
	end

end