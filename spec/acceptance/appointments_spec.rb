require 'acceptance_helper'

resource "预约存入衣服到我的衣橱" do
  header "Accept", "application/json"
  user_attrs = FactoryGirl.attributes_for(:user)
  
  header "X-User-Token", user_attrs[:authentication_token]
  header "X-User-Phone", user_attrs[:phone]
  before do
    @user = create(:user)
    @user_info = create(:user_info, user: @user)
    create_list(:vip_level, 4)
    # 创建价格表
    create_list(:store_method, 3)
    @stocking_chest = create(:stocking_chest) 
    @group_chest1 = create(:group_chest1)
    @alone_full_dress_chest = create(:alone_full_dress_chest)
    @vacuum_bag_medium = create(:vacuum_bag_medium)
    price_system_ary = [@stocking_chest, @group_chest1, @alone_full_dress_chest, @vacuum_bag_medium]
    @appointments = create_list(
      :appointment, 5,
      user: @user, 
      garment_count_info: {
        hanging: 15,
        full_dress: 5 }
      )
    price_system_ary.each do |price_system|
      create(:appointment_price_group, 
          appointment: @appointments.first,
          price_system: price_system
          )
    end
  end
  post '/appointments' do
    appointment_attrs = FactoryGirl.attributes_for(:appointment)

    parameter :address, "地址", require: true, scope: :appointment
    parameter :name, "预约人", require: true, scope: :appointment
    parameter :phone, "联系电话", require: true, scope: :appointment
    parameter :number, "衣服数量", require: true, scope: :appointment
    parameter :date, "预约日期", require: true, scope: :appointment

    let(:address) {appointment_attrs[:address]}
    let(:name) {appointment_attrs[:name]}
    let(:phone) {appointment_attrs[:phone]}
    let(:number) {appointment_attrs[:number]}
    let(:date) {appointment_attrs[:date]}

    example "用户预约存入衣服到我的衣橱成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  get 'appointments' do

    before do
      @user1 = create(:user1, created_at: Time.now-1.day)
      create(:user_info, user: @user1)
    end

    example "用户获取预约列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  get 'appointments/:id' do

    let(:id) { @appointments.first.id }

    example "用户查看指定预约详情成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  post 'appointments/:id/cancel' do

    let(:id) { @appointments.first.id }

    example "用户 取消 指定预约 成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  post 'appointments/:id/pay_by_balance' do

    before do
      @appointment = @appointments.first
      @appointment.accept!
      @appointment.service!
    end

    let(:id) { @appointment.id }

    example "用户使用余额支付成功" do
      do_request
      puts response_body
      p '--- @user.user_info.purchase_logs--'
      p @user.user_info.purchase_logs
      expect(status).to eq(201)
    end
  end

  post 'appointments/:id/pay_by_balance' do
    before do
      @user_info.balance = 100
      @user_info.save
      @appointment = @appointments.first
      @appointment.accept!
      @appointment.service!
    end

    let(:id) { @appointment.id }

    example "【change】用户余额不足，用使用余额支付失败" do
      do_request
      puts response_body
       p '--- @user.user_info.purchase_logs--'
      p @user.user_info.purchase_logs
      expect(status).to eq(422)
    end
  end

end