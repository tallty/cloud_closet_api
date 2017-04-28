# require 'acceptance_helper'

# resource '价目表相关' do
#   header 'Accept', 'application/json'

#   before do
#     create_list(:store_method, 3)
#     @user = create(:user)
#     @worker = create(:worker)
#     @stocking_chest = create(:stocking_chest) 
#     @group_chest1 = create(:group_chest1)
#   end

#   describe '【用户】' do
#     user_attrs = FactoryGirl.attributes_for(:user)

#     header 'X-User-Token', user_attrs[:authentication_token]
#     header 'X-User-Phone', user_attrs[:phone]

#     get '/price_systems' do

#       example '【user】获取所有柜子的价目介绍' do
#         do_request
#         puts response_body
#         expect(status).to eq(200)
#       end
#     end
#   end

#   describe '【工作人员】' do 
#     worker_attrs = FactoryGirl.attributes_for(:worker)

#     header "X-Worker-Token", worker_attrs[:authentication_token]
#     header "X-Worker-Phone", worker_attrs[:phone]

#     get 'worker/price_systems' do 
#       example '【worker】获取所有的价目介绍' do
#         p Worker.all
#         do_request
#         puts response_body
#         expect(status).to eq(200)
#       end
#     end
#   end

#   describe '【管理员】' do 
#     # 暂缓
#   end
# end