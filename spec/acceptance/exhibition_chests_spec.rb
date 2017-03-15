require 'acceptance_helper'

resource "我的衣橱" do
  header "Accept", "application/json"
  user_attrs = FactoryGirl.attributes_for(:user)

  header "X-User-Token", user_attrs[:authentication_token]
  header "X-User-Phone", user_attrs[:phone]
  before do
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
    	user: @user)
    @val_chest2 = create(:valuation_chest,
      price_system: @alone_full_dress_chest,
      user: @user)
    @val_chest3 = create(:valuation_chest,
      price_system: @alone_full_dress_chest,
      user: @user)
    # 

    @chest1 = create(:exhibition_chest, 
    	exhibition_unit: @stocking_chest.exhibition_units.first,
    	custom_title: 'aaaaa',
    	valuation_chest: @val_chest1,
    	user: @user
    	)
    # 正在入库的衣服
    @garments = create_list(
    	:garment, 3,
    	exhibition_chest: @exhi_chests.first,
      aasm_state: 'storing'
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
      expect(status).to eq(200)
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


  post 'exhibition_chests/:id/move_garment' do

    parameter :garment_ids, "选择的garment id 数组", require: true
    parameter :to_exhibition_chest_id, "目标衣柜", require: true

    let(:id) {@exhi_chests.first.id}
    let(:garment_ids) { @exhi_chests.first.garments.collect(&:id)[0,1] }
    let(:to_exhibition_chest_id) { @exhi_chests.second.id }

    example "用户 移动衣服（无验证）列表 成功" do
      p @exhi_chests.first.garments.count
      do_request
      puts response_body
      expect(status).to eq(201)
      p ';====after==='
      p @exhi_chests.first.garments.count
    end
  end

end