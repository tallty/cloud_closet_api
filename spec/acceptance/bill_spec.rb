# require 'acceptance_helper'

# resource "用户账单创建及查询" do
#   header "Accept", "application/json"

#   #################　index ###############
#   get '/bills' do
#     user_attrs = FactoryGirl.attributes_for(:user)

#     header "X-User-Token", user_attrs[:authentication_token]
#     header "X-User-Phone", user_attrs[:phone]
      
#         before do
#           @user = create(:user)
#           create_list(:bill, 5, user: @user)
#         end
    
#         parameter :page, "当前页", require: false
#         parameter :per_page, "每页的数量", require: false
    
#         example "用户查询自己的账单列表成功" do
#           do_request
#           puts response_body
#           expect(status).to eq(200)
#         end
#   end
#   ############## deposit_bill ###############
#   get '/bills/deposit_bill' do 
#         user_attrs = FactoryGirl.attributes_for(:user)

#         header "X-User-Token", user_attrs[:authentication_token]
#         header "X-User-Phone", user_attrs[:phone]
        
#         before do
#           @user = create(:user)
#           create_list(:bill, 5, user: @user)
#         end
    
#         parameter :page, "当前页", require: false
#         parameter :per_page, "每页的数量", require: false
    
#         example "用户查询自己的充值账单成功" do
#           do_request
#           puts response_body
#           expect(status).to eq(200)
#         end
#   end
  
#    ############## payment_bill ################
#   get '/bills/payment_bill' do
#         user_attrs = FactoryGirl.attributes_for(:user)

#         header "X-User-Token", user_attrs[:authentication_token]
#         header "X-User-Phone", user_attrs[:phone]
        
#         before do
#           @user = create(:user)
#           create_list(:bill, 5, user: @user)
#         end
    
#         parameter :page, "当前页", require: false
#         parameter :per_page, "每页的数量", require: false
    
#         example "用户查询自己的付款账单成功" do
#           do_request
#           puts response_body
#           expect(status).to eq(200)
#         end
#   end
  
#   ############## show ################
#   get '/bills/:id' do
#     user_attrs = FactoryGirl.attributes_for(:user)

#     header "X-User-Token", user_attrs[:authentication_token]
#     header "X-User-Phone", user_attrs[:phone]

#     before do
#       @user = create(:user)
#       @bills = create_list(:bill, 5, user: @user)
#     end
    
#     let(:id) {@bills.first.id}
    
#     example "用户查询自己的账单详情成功" do
#       do_request
#       puts response_body
#       expect(status).to eq(200)
#     end
#   end
#   ############## create ################
#   post '/bills' do
#     user_attrs = FactoryGirl.attributes_for(:user)
#     bill_attrs = FactoryGirl.attributes_for(:bill)
    
#     header "X-User-Token", user_attrs[:authentication_token]
#     header "X-User-Phone", user_attrs[:phone]

#     before do
#       @user = create(:user)
#     end

#     parameter :amount ,"金额数量",require: true,scope: :bill
#     parameter :sign ,"备注",require: true,scope: :bill

#     let(:amount) {bill_attrs[:amount]}
#     let(:sign) {bill_attrs[:sign]}
   
#     example "用户生成账单成功" do
#       do_request
#       puts response_body
#       expect(status).to eq(201)
#     end
#   end
# end  