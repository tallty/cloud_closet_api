# require 'acceptance_helper'

# resource "vip相关" do
# 	header "Accept", "application/json"
#   user_attrs = FactoryGirl.attributes_for(:user)
  
#   header "X-User-Token", user_attrs[:authentication_token]
#   header "X-User-Phone", user_attrs[:phone]

#   before do
#     @user = create(:user)
#     @user_info = create(:user_info, user: @user, credit: 100)

#     create_list(:vip_level)
#   end

# end