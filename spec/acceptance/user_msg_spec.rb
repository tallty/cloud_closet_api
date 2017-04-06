require 'acceptance_helper'

resource "vip相关" do
	before do
	  @user = create(:user)
	  @user_info = create(:user_info, user: @user, credit: 700)
	  create_list(:vip_level, 4)
	  @vip_service =   VipService.new(@user_info)
	  # [ '普通会员', '银卡会员', '金卡会员', '砖石卡会员' ]
   #  [ 0, 800, 6000, 20000 ]
	end	

	example '会员升级消息' do 
		p info_was = @vip_service.vip_in_user_info
		@vip_service.add(200)
		p info_now = VipService.new(@user.user_info).vip_in_user_info

		assert_equal(900, @user_info.credit)
		assert_equal('银卡会员', info_now[:level_now])


		p @user_info
		p @user.user_msgs
	end

end