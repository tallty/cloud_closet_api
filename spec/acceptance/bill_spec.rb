require 'acceptance_helper'

resource "用户余额扣除账单APi" do
  header "Accept", "application/json"

  ############### before_do ################################
  describe 'admin_appointment_items condition is all correct' do
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @user_info = create(:user_info, user: @user)
      @bills = create_list(:bill, 5, user: @user)
    end

    #################　index ###############
    get '/bills' do

      parameter :page, "当前页", require: false
      parameter :per_page, "每页的数量", require: false

      let(:page) {1}
      let(:per_page) {15}

      example "用户查询 账单列表" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end
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
    
    ############## show ################
    get '/bills/:id' do
      let(:id) {@bills.first.id}
      
      example "用户查询 指定的账单详情" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end
  end
end  