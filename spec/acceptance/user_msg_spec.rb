require 'acceptance_helper'

resource "消息中心相关" do
	header "Accept", "application/json"
	describe '【用户】' do 
		before do
		  @user = create(:user)
		  @user_info = create(:user_info, user: @user, credit: 700, balance: 0)
		  create_list(:vip_level, 4)
		  # [ '普通会员', '银卡会员', '金卡会员', '砖石卡会员' ]
	    # [ 0, 800, 6000, 20000 ]
		end	
		describe '非接口相关' do 
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
				# 下方 如何简洁 ??!!
				assert_equal( 1, @user.user_msgs.count )
				assert_equal( '您升级啦!', @user.user_msgs.first.title )
				assert_equal( '您想现在是尊贵的金卡会员！', @user.user_msgs.first.abstract )
				p '--- @user.purchase_logs --'
				p @user.purchase_logs
				p '--- @user.user_msgs --'
				p @user.user_msgs
			end
		end

		describe '接口相关' do 
	    before do 
	    	header "X-User-Phone", @user.phone
	    	header "X-User-Token", @user.authentication_token 
	    	@user_msgs = create_list(:user_msg, 3, user: @user)
	    	@public_msgs = create_list(:public_msg, 1)
    	end

    	get '/user_msg_center' do
	      example '用户 访问【消息中心】 获取所有消息（个人+公频）' do
	        do_request
	        puts response_body
	        expect(status).to eq(200)
	      end
	    end

	    get '/user_msgs' do
	      example '用户 获取所有 个人消息' do
	        do_request
	        puts response_body
	        expect(status).to eq(200)
	      end
	    end

	    get '/user_msgs/:id' do
	    	let(:id) { @user_msgs.first.id } 
	      example '用户 获取某一 个人消息' do
	        do_request
	        puts response_body
	        expect(status).to eq(200)
	      end
	    end

	    get '/public_msgs/:id' do
	    	let(:id) { @public_msgs.first.id } 
	      example '用户 获取某一 公频消息' do
	        do_request
	        puts response_body
	        expect(status).to eq(200)
	      end
	    end
		end

	end

	describe '管理员' do 

		before do 
			@admin = create(:admin)
			header "X-Admin-Email", @admin.email
			header "X-Admin-Token", @admin.authentication_token
			@public_msgs = create_list(:public_msg, 3)
		end
		get '/admin/public_msgs' do
      example '管理员 获取所有 公频消息' do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get '/admin/public_msgs/:id' do
    	let(:id) { @public_msgs.first.id } 
      example '管理员 获取某一 公频消息' do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post '/admin/public_msgs' do
    	public_msg_attrs = FactoryGirl.attributes_for(:public_msg)
			image_attrs = FactoryGirl.attributes_for(:image, photo_type: "public_msg")

    	parameter :title, '公频消息 标题', require: true, scope: :public_msg
    	parameter :abstract, '公频消息 摘要', require: true, scope: :public_msg
    	parameter :content, '公频消息 内容', require: true, scope: :public_msg
    	parameter :public_msg_image_attributes, '公频消息 配图', require: true, scope: :public_msg

 			let(:title) { public_msg_attrs[:title] }
 			let(:abstract) { public_msg_attrs[:abstract] }
 			let(:content) { public_msg_attrs[:content] }
    	let(:public_msg_image_attributes) { image_attrs }

      example '管理员 创建公频消息' do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    put '/admin/public_msgs/:id' do
    	public_msg_attrs = FactoryGirl.attributes_for(:public_msg)
			image_attrs = FactoryGirl.attributes_for(:image, photo_type: "public_msg")

    	parameter :title, '公频消息 标题', require: false, scope: :public_msg
    	parameter :abstract, '公频消息 摘要', require: false, scope: :public_msg
    	parameter :content, '公频消息 内容', require: false, scope: :public_msg
    	parameter :public_msg_image_attributes, '公频消息 配图', require: false, scope: :public_msg

 			let(:title) { public_msg_attrs[:title] }
 			# let(:abstract) { public_msg_attrs[:abstract] }
 			let(:content) { public_msg_attrs[:content] }
    	let(:public_msg_image_attributes) { image_attrs }

    	let(:id) { @public_msgs.first.id } 
      example '管理员 修改某一 公频消息' do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    delete '/admin/public_msgs/:id' do
    	let(:id) { @public_msgs.first.id } 
      example '管理员 删除某一 公频消息' do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end

	end
end