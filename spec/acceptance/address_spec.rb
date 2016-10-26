require 'acceptance_helper'

resource "用户收货地址查询修改" do
  header "Accept", "application/json"

  get '/addresses' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user,
      																default_address_id: 0	
						      				)
      create_list(:address, 5, user_info: @user_info)
    end

    parameter :page, "当前页", require: false
    parameter :per_page, "每页的数量", require: false

    let(:page) {1}
    let(:per_page) {2}

    example "用户查询收货地址列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end

  end
  
  #post '/addresses'
  put '/addresses/:id' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :name, "收货人姓名", require: false, scope: :address
    parameter :address_detail, "收货地址", require: false, scope: :address
    parameter :phone, "收货人电话", require: false, scope: :address

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user,
      																default_address_id: 4	
						      				)
      create_list(:address, 5, user_info: @user_info)
    end

    let(:id) {3}
    let(:name) { "new consignee_name" }
    let(:address_detail) { "new consignee_address" }
    let(:phone) { "new 13813813811" }


    example "用户修改收货地址信息成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  post '/addresses/:id/set_default' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user,
      																default_address_id: 1	)

      create_list(:address, 5, user_info: @user_info)
    end

    let(:id) {3}


    example "用户修改默认收货地址成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end
 

end