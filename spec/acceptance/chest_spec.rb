require 'acceptance_helper'

resource "我选择的的衣橱 相关api" do
  header "Accept", "application/json"

  ############### before_do ################################
  describe 'admin_appointment_items condition is all correct' do
  	user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @appointment = create(:appointment)
      @garment = create(:garment)
      @chests = create_list(:chest, 5, user: @user, appointment: @appointment)
      @chests.each do |chest|
        @items = create_list(:chest_item, 5, chest: chest, garment: @garment)
      end
    end
    
    ################# index #################
    get '/chests' do

      example "用户查询我的衣橱 列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    ################# index #################
    get '/chests/:id' do
      let(:id) {@chests.first.id}

      example "用户查询 我的衣橱 详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    ################# index #################
    delete '/chests/:id' do
      let(:id) {@chests.first.id}

      example "用户 删除 指定我的衣橱成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end
  end  


end