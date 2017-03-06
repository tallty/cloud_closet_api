require 'acceptance_helper'

resource "我的衣橱" do
  header "Accept", "application/json"

  user_attrs = FactoryGirl.attributes_for(:user)

  header "X-User-Token", user_attrs[:authentication_token]
  header "X-User-Phone", user_attrs[:phone]

  before do
  	create_list(:store_method, 3)
  	create_list(:garment_tag, 3)
  	@user = create(:user)
  	@stocking_chest = create(:stocking_chest) 
  	@exhibition_chest = create(:exhibition_chest, 
  		user: @user,
  		exhibition_unit: @stocking_chest.exhibition_units.first
  		)
    @garments = create_list(:garment, 3, 
    	user: @user, 
    	exhibition_chest: @exhibition_chest,
    	status: 'stored',
      tag_list: '半裙'
    	)
  end

  put 'garments/:id' do
    parameter :add_tag_list, "【添加的】标签 组成的字符串，以英文逗号',' 分隔各标签", required: true, scope: :garment
    parameter :remove_tag_list, "【删除的】标签 组成的字符串，以英文逗号',' 分隔各标签", required: true, scope: :garment

    let(:add_tag_list) { '上衣' } 
    let(:remove_tag_list) { '半裙' } 
    let(:id) { @garments.first.id }

    example '用户编辑衣服, ‘添加标签’' do
    	p @garments.first
      do_request
      puts response_body
      expect(status).to eq(201)
    end
  end



  # get '/garments' do

  #   parameter :page, "当前页", require: false
  #   parameter :per_page, "每页的数量", require: false

  #   let(:page) {2}
  #   let(:per_page) {2}

  #   example "用户查询我的衣橱中的衣服列表成功" do
  #     do_request
  #     puts response_body
  #     expect(status).to eq(200)
  #   end
  # end

  # get 'garments/:id' do
  #   user_attrs = FactoryGirl.attributes_for(:user)

  #   header "X-User-Token", user_attrs[:authentication_token]
  #   header "X-User-Phone", user_attrs[:phone]

  #   before do
  #     @user = create(:user)
  #     @garments = create_list(:garment, 5, user: @user)
  #   end

  #   let(:id) {@garments.first.id}

  #   example "用户查询我的衣橱指定衣服详情成功" do
  #     do_request
  #     puts response_body
  #     expect(status).to eq(200)
  #   end
  # end

end