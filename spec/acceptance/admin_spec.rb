require 'acceptance_helper'

resource "管理后台相关接口" do
  header "Accept", "application/json"

  # describe 'admin authentication' do

  #   before do
  #     @admin = create(:admin)
  #   end

  #   post "/admins/sign_in" do

  #     parameter :email, "登录的邮箱", required: true, scope: :admin
  #     parameter :password, "登录密码", required: true, scope: :admin

  #     admin_attrs = FactoryGirl.attributes_for :admin
  #     let(:email) { admin_attrs[:email] }
  #     let(:password) { admin_attrs[:password] }

  #     response_field :id, "用户ID"
  #     response_field :email, "邮箱"
  #     response_field :created_at, "创建时间"
  #     response_field :updated_at, "更新时间"
  #     response_field :authentication_token, "鉴权Token"

  #     example "管理员登录成功" do
  #       do_request
  #       puts response_body
  #       expect(status).to eq(201)
  #     end
  #   end
  # end

  describe 'appointment condition is all correct' do
    admin_attrs = FactoryGirl.attributes_for(:admin)

    header "X-Admin-Token", admin_attrs[:authentication_token]
    header "X-Admin-Email", admin_attrs[:email]

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
		      :appointment, 4,
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

      @appointments.second.accept!
      @appointments.second.service!
      @appointments.second.pay!
      @appointments.second.storing!
	    @appointments.second.stored! #??

	    @exhibition_chests = @user.exhibition_chests
	    # 创建用户原有衣柜
	    @valuation_chest = create(:valuation_chest,
	    	price_system: @stocking_chest,
	    	user: @user)
	    @exhibition_chest1 = create(:exhibition_chest, 
	    	exhibition_unit: @stocking_chest.exhibition_units.first,
	    	custom_title: 'aaaaaaaaaaaaaa',
	    	valuation_chest: @valuation_chest,
	    	user: @user
	    	)
	    @garments = create_list(
	    	:garment, 3,
	    	exhibition_chest: @exhibition_chests.first,
	    	) 
    end

    get 'admin/appointments' do

      parameter :page, "当前页", require: false
      parameter :per_page, "每页的数量", require: false

      parameter :query_state, "输入查询的状态(storing: 入库中，stored: 已上架)", require: false
      let(:query_state) {"stored"}

      example "管理员查询所有‘已上架'或者‘入库中‘的预订订单的列表成功" do
        do_request
        puts response_body
        expect(status).to eq 200
      end
    end

    get 'admin/appointments/:id' do
      let(:id) { @appointments.first.id }

      example "管理员查看指定的预订订单详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/appointments/:id/its_chests' do
    	let(:id) { @appointments.first.id }
      example "【new】管理员获取指定的订单下面的所有 该用户可操作衣柜 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post 'admin/exhibition_chests/:id/garments' do
      image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")
      garment_attrs = FactoryGirl.attributes_for(:garment)

      parameter :appointment_id, "当前订单id", required: true

      parameter :title, "衣服描述信息", require: false, scope: :garment
      parameter :row, "衣服存放的 排 ", require: false, scope: :garment
      parameter :carbit, "衣服存放的 柜 ", require: false, scope: :garment
      parameter :place, "衣服存放的 位 ", require: false, scope: :garment
      parameter :cover_image_attributes, "衣服的封面图", require: false, scope: :garment
      parameter :detail_image_1_attributes, "衣服的详细图片1", require: false, scope: :garment
      parameter :detail_image_2_attributes, "衣服的详细图片2", require: false, scope: :garment
      parameter :detail_image_3_attributes, "衣服的详细图片3", require: false, scope: :garment

      let(:id) { @exhibition_chests.first.id }

      let(:store_month) { 12 }
      let(:title) { "garemnt title" }
      let(:row) { 1 }
      let(:carbit) { 3 }
      let(:place) { 2 }
      let(:cover_image_attributes) { image_attrs }
      let(:detail_image_1_attributes) { image_attrs }
      let(:detail_image_2_attributes) { image_attrs }
      let(:detail_image_3_attributes) { image_attrs }

      example "【new】管理员创建 对应衣柜中的衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    put 'admin/exhibition_chests/:id/garments/:id' do
      image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")

      parameter :appointment_id, "当前订单id", required: true

      parameter :title, "衣服描述信息", require: false, scope: :garment
      parameter :row, "衣服存放的 排 ", require: false, scope: :garment
      parameter :carbit, "衣服存放的 柜 ", require: false, scope: :garment
      parameter :place, "衣服存放的 位 ", require: false, scope: :garment
      parameter :cover_image_attributes, "衣服的封面图", require: false, scope: :garment
      parameter :detail_image_1_attributes, "衣服的详细图片1", require: false, scope: :garment
      parameter :detail_image_2_attributes, "衣服的详细图片2", require: false, scope: :garment
      parameter :detail_image_3_attributes, "衣服的详细图片3", require: false, scope: :garment

      let(:exhibition_chest_id) { @exhibition_chests.first.id }
      let(:id) { @exhibition_chests.first.garments.first.id }
      let(:store_month) { 12 }
      let(:title) { "garemnt title" }
      let(:row) { 1 }
      let(:carbit) { 3 }
      let(:place) { 2 }
      let(:cover_image_attributes) { image_attrs }
      let(:detail_image_1_attributes) { image_attrs }
      let(:detail_image_2_attributes) { image_attrs }
      let(:detail_image_3_attributes) { image_attrs }

      example "【rewrite】管理员修改 对应衣柜中的衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    get 'admin/exhibition_chests/:id/garments' do
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "【new】管理员某衣柜的所有衣服 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/exhibition_chests/:id/garments/:id' do
      let(:exhibition_chest_id) { @exhibition_chests.first }
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "【new】管理员某衣柜中 某一衣服 成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/garments/:id' do
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "管理员查看衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    delete 'admin/garments/:id' do
      let(:id) { @exhibition_chests.first.garments.first.id }

      example "管理员删除 衣服 成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end

    # 上架订单  扣取本次新柜子本月租费!!!
    post '/admin/appointments/:id/stored' do
      let(:id) { @appointments.first.id }

      example "管理员‘确认上架’指定预订订单成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
        p '----- purchar_log------'
        p @user.purchase_logs
      end
    end


    post 'admin/exhibition_chests/:id/release' do 
      let(:id) { @exhibition_chests.first.id }
    	example "管理员‘发布某衣柜’成功，可多次发布" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
  	end

  end

  describe '价格系统操作' do
    admin_attrs = FactoryGirl.attributes_for(:admin)
    price_system_attrs = FactoryGirl.attributes_for(:stocking_chest)

    header "X-Admin-Token", admin_attrs[:authentication_token]
    header "X-Admin-Email", admin_attrs[:email]

    before do
      create_list(:store_method, 3)
      @admin = create(:admin)
      @group_chest1 = create(:group_chest1)
      @alone_full_dress_chest = create(:alone_full_dress_chest)
      @vacuum_bag_medium = create(:vacuum_bag_medium)
      @price_systems = PriceSystem.all
    end

    get 'admin/price_systems' do

      parameter :page, "当前页", required: false
      parameter :per_page, "每页的数量", required: false

      let(:page) {2}
      let(:per_page) {2}

      example "管理员查询价目列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/price_systems/:id' do

      let(:id) {@price_systems.first.id}

      example "管理员查询某价目详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    post 'admin/price_systems' do

      let(:id) {@price_systems.first.id}

      parameter :title, "衣服类型名称", required: true, scope: :price_system
      parameter :price, "单价", required: true, scope: :price_system
      parameter :is_chest, "是否为衣柜", required: true, scope: :price_system
      parameter :unit_name, '单位名称', required: true, scope: :price_system
      parameter :description, "简介", required: false, scope: :price_system
      parameter :price_icon_image, "封面图", require: true, scope: :price_system

      let(:title) { 'new_title' }
      let(:price) { 999 }
      let(:is_chest) { true }
      let(:unit_name) { '月' }
      let(:description) { '我是简介简介简介简介' }
      let(:price_icon_image) { price_system_attrs[:price_icon_image] }

      example "管理员创建价目信息成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    # put 'admin/price_systems/:id' do

    #   let(:id) {@price_systems.first.id}

    #   parameter :name, "价目的衣服类型名称", required: false, scope: :price_system
    #   parameter :season, "价目的衣服季节", required: false, scope: :price_system
    #   parameter :price, "价目的单价", required: false, scope: :price_system

    #   let(:name) { "new 上衣" }
    #   let(:season) { "new 春夏" }
    #   let(:price) { "2333" }

    #   example "管理员修改某价目信息成功" do
    #     do_request
    #     puts response_body
    #     expect(status).to eq(201)
    #   end
    # end

    # delete 'admin/price_systems/:id' do

    #   let(:id) {@price_systems.first.id}

    #   example "管理员删除某价目成功" do
    #     do_request
    #     puts response_body
    #     expect(status).to eq(204)
    #   end
    # end

  end

end