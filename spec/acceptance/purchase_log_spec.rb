require 'acceptance_helper'

resource "用户账户账单查看" do
  header "Accept", "application/json"

  get '/purchase_logs' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user)
      create_list(:purchase_log, 10, user_info: @user_info)
    end

    parameter :page, "当前页", required: false
    parameter :per_page, "每页的数量", required: false

    let(:page) {1}
    let(:per_page) {5}

    example "用户查询账户账单列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end

  end

  get '/purchase_logs/:id' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user)
      @purchase_logs = create_list(:purchase_log, 5, user_info: @user_info)
    end

    let(:id) {@purchase_logs.first.id}

    example "用户账户账单详情查看成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

end