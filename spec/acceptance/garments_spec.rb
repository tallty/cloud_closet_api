require 'acceptance_helper'

resource "我的衣橱" do
  header "Accept", "application/json"

  get '/garments' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      create_list(:garment, 5, user: @user)
    end

    parameter :page, "当前页", require: false
    parameter :per_page, "每页的数量", require: false

    let(:page) {2}
    let(:per_page) {2}

    example "用户查询我的衣橱中的衣服列表成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  get 'garments/:id' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @garments = create_list(:garment, 5, user: @user)
    end

    let(:id) {@garments.first.id}

    example "用户查询我的衣橱指定衣服详情成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

end