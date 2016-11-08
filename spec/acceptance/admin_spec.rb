require 'acceptance_helper'

resource "管理后台相关接口" do
  header "Accept", "application/json"

  describe 'admin authentication' do

    before do
      @admin = create(:admin)
    end

    post "/admins/sign_in" do

      parameter :email, "登录的邮箱", required: true, scope: :admin
      parameter :password, "登录密码", required: true, scope: :admin

      admin_attrs = FactoryGirl.attributes_for :admin
      let(:email) { admin_attrs[:email] }
      let(:password) { admin_attrs[:password] }

      response_field :id, "用户ID"
      response_field :email, "邮箱"
      response_field :created_at, "创建时间"
      response_field :updated_at, "更新时间"
      response_field :authentication_token, "鉴权Token"

      example "管理员登录成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end
  end

  describe 'appointment condition is all correct' do
    admin_attrs = FactoryGirl.attributes_for(:admin)

    header "X-Admin-Token", admin_attrs[:authentication_token]
    header "X-Admin-Email", admin_attrs[:email]

    before do
      @user = create(:user)
      @admin = create(:admin)
      storing_appointments = create_list(:appointment, 3, user: @user, aasm_state:"storing")
      stored_appointments = create_list(:appointment, 3, user: @user, aasm_state:"stored")
      @appointments = storing_appointments.concat stored_appointments
      @appointments.each do |appointment|
        @groups = create_list(:appointment_item_group, 3, appointment: appointment)
      end
      @groups.each do |group|
        @items = create_list(:appointment_item, 3, appointment_item_group: group)
      end
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

    post '/admin/appointments/:id/stored' do
      let(:id) { @appointments.first.id }

      example "管理员‘确认上架’指定预订订单成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/appointments/:appointment_id/appointment_item_groups' do
      let(:appointment_id) { @appointments.first.id }
      example "管理员获取指定的订单下面的所有订单组成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/appointment_item_groups/:appointment_item_group_id/garments' do
      let(:appointment_item_group_id) { @groups.first.id }
      example "管理员获取指定的订单下面的订单组对应的衣服列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    put 'admin/garments/:id' do
      image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")

      parameter :title, "衣服描述信息", require: false, scope: :garment
      parameter :row, "衣服存放的 排 ", require: false, scope: :garment
      parameter :carbit, "衣服存放的 柜 ", require: false, scope: :garment
      parameter :place, "衣服存放的 位 ", require: false, scope: :garment
      parameter :cover_image_attributes, "衣服的封面图", require: false, scope: :garment
      parameter :detail_images_attributes, "衣服的详细图片", require: false, scope: :garment

      let(:id) { @groups.first.garments.first.id }
      let(:title) { "garemnt title" }
      let(:row) { 1 }
      let(:carbit) { 3 }
      let(:place) { 2 }
      let(:cover_image_attributes) { image_attrs }
      let(:detail_images_attributes) { [image_attrs, image_attrs] }

      example "管理员完善衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq 201
      end
    end

    get 'admin/garments/:id' do
      let(:id) { @groups.first.garments.first.id }

      example "管理员查看衣服的详细信息成功" do
        do_request
        puts response_body
        expect(status).to eq 200
      end
    end
  end

  describe '价格系统操作' do
    admin_attrs = FactoryGirl.attributes_for(:admin)
    price_system_attrs = FactoryGirl.attributes_for(:price_system)

    header "X-Admin-Token", admin_attrs[:authentication_token]
    header "X-Admin-Email", admin_attrs[:email]

    before do
      @admin = create(:admin)
      @price_systems = create_list(:price_system, 5)
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

      parameter :name, "价目的衣服类型名称", required: true, scope: :price_system
      parameter :season, "价目的衣服季节", required: true, scope: :price_system
      parameter :price, "价目的单价", required: true, scope: :price_system

      let(:name) { price_system_attrs[:name] }
      let(:season) { price_system_attrs[:season] }
      let(:price) { price_system_attrs[:price] }

      example "管理员创建价目信息成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    put 'admin/price_systems/:id' do

      let(:id) {@price_systems.first.id}

      parameter :name, "价目的衣服类型名称", required: false, scope: :price_system
      parameter :season, "价目的衣服季节", required: false, scope: :price_system
      parameter :price, "价目的单价", required: false, scope: :price_system

      let(:name) { "new 上衣" }
      let(:season) { "new 春夏" }
      let(:price) { "2333" }

      example "管理员修改某价目信息成功" do
        do_request
        puts response_body
        expect(status).to eq(201)
      end
    end

    delete 'admin/price_systems/:id' do

      let(:id) {@price_systems.first.id}

      example "管理员删除某价目成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end

  end

end