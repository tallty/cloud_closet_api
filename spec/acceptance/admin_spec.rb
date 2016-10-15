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
      @appointments = create_list(:appointment, 5, user: @user)
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

      example "管理员查询所有预订订单的列表" do
        do_request
        puts response_body
        expect(status).to eq 200
      end
    end

    get 'admin/appointments/:id' do
      let(:id) { @appointments.first.id }

      example "管理员查看指定预订订单详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/appointments/:appointment_id/appointment_item_groups' do
      let(:appointment_id) { @appointments.first.id }
      example "管理员获取指定订单下面的所有订单组成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    get 'admin/appointment_item_groups/:appointment_item_group_id/garments' do
      let(:appointment_item_group_id) { @groups.first.id }
      example "管理员获取指定订单下面的订单组对应的衣服列表成功" do
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

      let(:id) { @groups.first.garments.first.id }
      let(:title) { "garemnt title" }
      let(:row) { 1 }
      let(:carbit) { 3 }
      let(:place) { 2 }
      let(:cover_image_attributes) { image_attrs }

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

end