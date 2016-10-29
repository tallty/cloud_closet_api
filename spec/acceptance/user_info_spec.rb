require 'acceptance_helper'

resource "用户信息查询修改" do
  header "Accept", "application/json"

  get '/user_info' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      create_list(:garment, 5, user: @user)
    end

    example "用户查询自己的信息成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  put 'user_info' do
    user_attrs = FactoryGirl.attributes_for(:user)
    image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :nickname, "称谓", require: false, scope: :user_info
    parameter :mail, "邮箱", require: false, scope: :user_info
    parameter :avatar_attributes, "头像", require: false, scope: :user_info
    # parameter :default_address_id, "默认地址id", require: false, scope: :user_info
    # parameter :balance, "用户余额", require: false, scope: :user_info

    before do
      @user = create(:user)
    end

    let(:nickname) { "new nickname" }
    let(:mail) { "new mail" }
    let(:avatar_attributes) { image_attrs }


    example "用户修改自己的信息成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end

  post 'user_info/bind' do
    user_attrs = FactoryGirl.attributes_for(:user)
    image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :openid, "微信openid", require: true, scope: :user

    before do
      @user = create(:user)
      create(:user_info, user: @user)
    end

    let(:openid) { "new openid" }

    example "用户绑定微信openid和系统帐号成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end

  end

  post 'user_info/check_openid' do
    user_attrs = FactoryGirl.attributes_for(:user)
    image_attrs = FactoryGirl.attributes_for(:image, photo_type: "avatar")

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :openid, "微信openid", require: true, scope: :user

    describe '查询已存在的用户信息' do
      before do
        @user = create(:user)
      end
      let(:openid) { @user.openid }
      example "用户查询已存在的微信openid对应的用户鉴权信息成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end  
    end

    describe "查询不存在的用户信息" do
      let(:openid) { "new openid" }
      example "用户查询不存在该微信openid的用户，返回错误的信息" do
        do_request
        puts response_body
        expect(status).to eq(404)
      end 
    end

    describe "openid的参数是空" do
      let(:openid) { "" }
      example "用户查询的微信openid为空，返回错误的信息" do
        do_request
        puts response_body
        expect(status).to eq(404)
      end 
    end
       

  end

end