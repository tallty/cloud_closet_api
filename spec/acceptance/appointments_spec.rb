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
    parameter :number, "上门地址", require: true, scope: :appointment
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
      @appointments = create_list(:appointment, 5, user: @user)
    end

    parameter :page, "当前页", require: false
    parameter :per_page, "每页的数量", require: false

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

end