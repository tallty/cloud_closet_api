require 'acceptance_helper'

resource "预约存入衣服到我的衣橱" do
  header "Accept", "application/json"

  post '/appointments' do
    user_attrs = FactoryGirl.attributes_for(:user)
    appointment_attrs = FactoryGirl.attributes_for(:appointment)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
    end

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
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      create(:user1, created_at: Time.now-1.day)
      @appointments = create_list(:appointment, 5, user: @user)
    end

    example "用户获取预约列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  get 'appointments/:id' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @appointments = create_list(:appointment, 5, user: @user)
    end

    let(:id) { @appointments.first.id }

    example "用户查看指定预约详情成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  post 'appointments/:id/cancel' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @appointments = create_list(:appointment, 5, user: @user)
    end

    let(:id) { @appointments.first.id }

    example "用户 取消 指定预约 成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  post 'appointments/:id/pay_by_balance' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user)
      @appointments = create_list(:appointment, 5, user: @user)
      @appointment = @appointments.first
      @appointment.accept!
      @appointment.service!
    end

    let(:id) { @appointment.id }

    example "用户使用余额支付成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  post 'appointments/:id/pay_by_balance' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user, balance: 100.00)
      @appointments = create_list(:appointment, 5, user: @user, price: 30000)
      @appointment = @appointments.first
      @appointment.accept!
      @appointment.service!
    end

    let(:id) { @appointment.id }

    example "用户余额不足，用使用余额支付失败" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

end