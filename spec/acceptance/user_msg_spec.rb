require 'acceptance_helper'

resource "消息中心相关" do
	describe '用户' do 
		before do
		  @user = create(:user)
		  @user_info = create(:user_info, user: @user, credit: 700, balance: 0)
		  create_list(:vip_level, 4)
		  # [ '普通会员', '银卡会员', '金卡会员', '砖石卡会员' ]
	    # [ 0, 800, 6000, 20000 ]
		end	

		example '积分增加，会员升级消息' do 
			p info_was = VipService.new(@user_info).vip_in_user_info
			VipService.new(@user_info).credit_add(200)
			p info_now = VipService.new(@user.user_info).vip_in_user_info

			assert_equal(900, @user_info.credit)
			assert_equal('银卡会员', info_now[:level_now], '确认会员名称')

			assert_equal( 1, @user.user_msgs.count, '生成user_msgs' )
			p 'user_msgs 内容为'
			p @user.user_msgs
		end

		example '
			充值, 
			生成消费记录(purchase_log),
			生成用户消息(user_msg)
			' do 

			user_info_was = @user_info.clone.freeze
			@ping_request = @user.ping_requests.create(
				amount: 10000 * 100, # pingpp 实际金额需缩小100倍
	      credit: 233,
				openid: @user.openid,
				)
			PurchaseLogService.new(
				@user, ['pingpp_recharge', 'credit'],
				ping_request: @ping_request
				).create

			assert_equal( user_info_was.balance + 10000 + 233, @user.user_info.balance, '确认余额增加')
			assert_equal( user_info_was.credit + 10000 + 233, @user.user_info.credit, '确认积分增加')
			# 下方 如何简洁
			assert_equal( 1, @user.user_msgs.count )
			assert_equal( '您升级啦!', @user.user_msgs.first.title )
			assert_equal( '您想现在是尊贵的金卡会员！', @user.user_msgs.first.abstract )
			p '--- @user.purchase_logs --'
			p @user.purchase_logs
			p '--- @user.user_msgs --'
			p @user.user_msgs
		end


	end

end