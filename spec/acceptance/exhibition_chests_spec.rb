require 'acceptance_helper'

resource "我的衣橱" do
  header "Accept", "application/json"
  user_attrs = FactoryGirl.attributes_for(:user)

  header "X-User-Token", user_attrs[:authentication_token]
  header "X-User-Phone", user_attrs[:phone]
  before do
    allow_any_instance_of(WechatMessageService).to receive(:send_msg) {
      @sent = true
    }
    create_list(:vip_level, 4)
  	# 创建价格表
    create_list(:store_method, 3)
    @stocking_chest = create(:stocking_chest) 
    @group_chest1 = create(:group_chest1)
    @alone_full_dress_chest = create(:alone_full_dress_chest)
    @vacuum_bag_medium = create(:vacuum_bag_medium)

    @user = create(:user)
    @user_info = create(:user_info, user: @user)
    @admin = create(:admin)
    price_system_ary = [@stocking_chest, @group_chest1, @alone_full_dress_chest, @vacuum_bag_medium]
    @appointments = create_list(
	      :appointment, 3,
	      user: @user, 
	      garment_count_info: {
	        hanging: 15,
	        full_dress: 5 
	      }
	      )
    price_system_ary.each do |price_system|
      create(:appointment_price_group, 
          appointment: @appointments.first,
          price_system: price_system
          )
    end
    @appointments.first.accept!
    @appointments.first.service!
    @appointments.first.pay!
    @appointments.first.storing!

   #  @appointments.second.accept!
   #  @appointments.second.service!
   #  @appointments.second.pay!
   #  @appointments.second.storing!
    # @appointments.second.stored! #??

    @exhi_chests = @user.exhibition_chests
    # 创建用户原有衣柜
    @val_chest1 = create(:valuation_chest,
    	price_system: @stocking_chest,
    	user: @user,
      appointment_price_group: AppointmentPriceGroup.first
      )
    @val_chest2 = create(:valuation_chest,
      price_system: @alone_full_dress_chest,
    	user: @user,
      appointment_price_group: AppointmentPriceGroup.first
      )
    @val_chest3 = create(:valuation_chest,
      price_system: @alone_full_dress_chest,
    	user: @user,
      appointment_price_group: AppointmentPriceGroup.first
      )
    # 组合柜
    @val_chest4 = create(:valuation_chest,
      price_system: @group_chest1,
    	user: @user,
      appointment_price_group: AppointmentPriceGroup.first
      )

    @chest1 = create(:exhibition_chest, 
    	exhibition_unit: @stocking_chest.exhibition_units.first,
    	custom_title: 'aaaaa',
    	valuation_chest: @val_chest1,
    	user: @user
    	)
    @chest2_group1 = create(:exhibition_chest, 
      exhibition_unit: @group_chest1.exhibition_units.first,
      custom_title: '组合柜哈哈航啊',
      valuation_chest: @val_chest4,
      user: @user
      )

    @chest2_group2 =  create(:exhibition_chest, 
      exhibition_unit: @group_chest1.exhibition_units.second,
      custom_title: '组合柜哈哈航啊222',
      valuation_chest: @val_chest4,
      user: @user
      )
    # 正在入库的衣服
    @garments = create_list(
    	:garment, 3,
    	exhibition_chest: @exhi_chests.first,
      status: 'storing'
    	) 
    @exhi_chests.each {|x|x.release!}
    # test alone_full_dress_chest view output
    @chest2 = create(:exhibition_chest,
      exhibition_unit: @alone_full_dress_chest.exhibition_units.first,
      custom_title: '单件礼服柜1',
      valuation_chest: @val_chest2,
      user: @user,
      aasm_state: 'online'
      )

    @chest3 = create(:exhibition_chest, 
      exhibition_unit: @alone_full_dress_chest.exhibition_units.first,
      custom_title: '单件礼服柜2',
      valuation_chest: @val_chest3,
      user: @user,
      aasm_state: 'online'
      )

    create(:garment, 
      exhibition_chest: @chest2, 
      status: 'stored', 
      title: '单件礼服1'
      )

    create_list(:garment, 2,
      exhibition_chest: @chest3, 
      status: 'stored', 
      title: '单件礼服2'
      )
  end


  get '/exhibition_chests' do

    example "用户查询我的衣橱 衣柜列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  get 'exhibition_chests/:id' do

    let(:id) {@exhi_chests.first.id}

    example "用户查询我的衣橱 某衣柜【非单件礼服】详情成功" do
      do_request
      puts response_body
      res = JSON.parse(response_body)
      expect(res['garments'].count).to eq(@exhi_chests.first.garments.count)
      expect(status).to eq(200)
    end

    describe 'Find by tags' do
      parameter :tags, '标签的数组'

      before do
        @tagged_garment = @exhi_chests.first.garments.first
        @tagged_garment.tag_list.add(['test-tag'])
        @tagged_garment.save
      end
      let(:id) {@exhi_chests.first.id}
      let(:tags) { ['test-tag'] }

      example "用户查询我的衣橱 某衣柜 详情成功【标签查询，各条件结果相交🍌" do
        do_request
        puts response_body
        res = JSON.parse(response_body)
        expect(res['garments'].count).to eq(1)
        expect(status).to eq(200)
      end

    end
  end

  get 'exhibition_chests/:id' do

    let(:id) {@chest3.id}

    example "用户查询我的衣橱 某衣柜（单件礼服）详情成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  get 'exhibition_chests/:id/the_same_store_method' do

    let(:id) {@exhi_chests.first.id}

    example "用户查询某柜子 可移动的柜子（含无空间）列表 成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end


  # post 'exhibition_chests/:id/move_garment' do

  #   parameter :garment_ids, "选择的garment id 数组", require: true
  #   parameter :to_exhibition_chest_id, "目标衣柜", require: true

  #   let(:id) {@exhi_chests.first.id}
  #   let(:garment_ids) { @exhi_chests.first.garments.collect(&:id)[0,1] }
  #   let(:to_exhibition_chest_id) { @exhi_chests.second.id }

  #   example "用户 移动衣服（无验证）列表 成功" do
  #     p @exhi_chests.first.garments.count
  #     do_request
  #     puts response_body
  #     expect(status).to eq(201)
  #     p ';====after==='
  #     p @exhi_chests.first.garments.count
  #   end
  # end

  put 'exhibition_chests/:id' do

    parameter :custom_title, '自定义衣柜名', scope: :exhibition_chest
    let(:id) {@exhi_chests.first.id}
    let(:custom_title) { '我是 用户自定义衣柜名称' }

    example "用户修该衣柜属性，（现只支持 自定义衣柜名）" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  # post 'exhibition_chests/:id/delete_his_val_chest' do

  #   let(:id) {@chest2_group1.id}

  #   example "用户 释放衣柜 成功" do
      
  #     do_request
  #     puts response_body
  #     expect(status).to eq(201)
  #   end

  #   describe '失败' do 
  #     before do 
  #       create_list(
  #         :garment, 3,
  #         exhibition_chest: @chest2_group1,
  #         status: 'stored'
  #         ) 
  #     end
  #     example "用户 释放衣柜 失败" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(422)
  #     end
  #   end
  # end

end