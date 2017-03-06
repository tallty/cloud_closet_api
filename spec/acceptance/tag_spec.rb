require 'acceptance_helper'

resource '标签 相关' do
  header 'Accept', 'application/json'

  before do
    # 衣服标签
    create_list(:garment_tag, 3)
    @user = create(:user)
    @worker = create(:worker)
    @admin = create(:admin)
  end

  get '/constant_tags' do
    parameter :class_name, '标签类型', required: false

    example '获取所有 固定标签（ 默认为衣服标签 ）' do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end


  describe '【用户】' do
    # 自定义标签  暂缓
    user_attrs = FactoryGirl.attributes_for(:user)

    header 'X-User-Token', user_attrs[:authentication_token]
    header 'X-User-Phone', user_attrs[:phone]
    
  end

  describe '【管理员】' do 
    # 编辑固定标签

  end
end