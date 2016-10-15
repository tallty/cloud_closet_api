require 'acceptance_helper'

resource "管理后台相关接口" do
  header "Accept", "application/json"

  describe 'appointment condition is all correct' do
    admin_attrs = FactoryGirl.attributes_for(:admin)

    header "X-Admin-Token", admin_attrs[:authentication_token]
    header "X-Admin-Email", admin_attrs[:email]

    before do
      @user = create(:user)
      @admin = create(:admin)
      @appointments = create_list(:appointment, 5, user: @user)
      @appointments.each do |appointment|
        create_list(:appointment_item_group, 3, appointment: appointment)
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

  end

end