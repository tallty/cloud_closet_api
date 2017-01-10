require 'acceptance_helper'

resource "我选择的的衣橱 相关api" do
  header "Accept", "application/json"

  ############### before_do ################################
  describe 'chests condition is all correct' do
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

    ################# show #################
    get '/chests/:id' do
      let(:id) {@chests.first.id}

      example "用户查询 我的衣橱 详情成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end

    ################# delete #################
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

resource "衣橱中存储的衣服 相关api" do
  header "Accept", "application/json"

  ############### before_do ################################
  describe 'chest_items condition is all correct' do
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
    get '/chests/:chest_id/chest_items' do
      let(:chest_id) {@chests.first.id}

      parameter :page, "当前页", require: false
      parameter :per_page, "每页的数量", require: false

      let(:page) {1}
      let(:per_page) {15}

      example "用户查询 衣橱中存储的衣服 列表成功" do
        do_request
        puts response_body
        expect(status).to eq(200)
      end
    end
    
    ################# delete #################
    delete '/chests/:chest_id/chest_items/:id' do
      let(:chest_id) {@chests.first.id}
      let(:id) {@items.first.id}

      example "用户 从衣橱移除 指定的衣服成功" do
        do_request
        puts response_body
        expect(status).to eq(204)
      end
    end
  end 

  ################# create #################
  post '/chests/:chest_id/chest_items' do
    user_attrs = FactoryGirl.attributes_for(:user)
    chest_item_attrs = FactoryGirl.attributes_for(:chest_item)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      @user = create(:user)
      @appointment = create(:appointment)
      @chests = create_list(:chest, 5, user: @user, appointment: @appointment)
    end

    parameter :chest_id, "衣橱", require: true, scope: :chest_item
    parameter :garment_id, "衣服", require: true, scope: :chest_item
    
    let(:chest_id) {chest_item_attrs[:chest_id]}
    let(:garment_id) {chest_item_attrs[:garment_id]}

    example "用户 往衣橱添加 衣服成功" do
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end 
end

