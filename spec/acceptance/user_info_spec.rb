require 'acceptance_helper'

resource "用户信息查询修改" do
  header "Accept", "application/json"

  get '/user_info' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user)
    end

    example "用户查询自己的信息成功" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

end