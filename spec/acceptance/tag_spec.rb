# require 'acceptance_helper'

# resource '标签 相关' do
#   header 'Accept', 'application/json'

#   before do
#     # 衣服标签
#     @constants = create_list(:garment_tag, 3)
#     @user = create(:user)
#     @worker = create(:worker)
#     @admin = create(:admin)
#   end

#   describe '获取所有固定标签' do
#     get '/constant_tags' do
#       parameter :class_name, '标签类型', required: false

#       example '获取所有 固定标签（ 默认为衣服标签 ）' do
#         do_request
#         puts response_body
#         expect(status).to eq(200)
#       end
#     end
#   end

#   describe '【用户】' do
#     # 添加自定义标签  暂缓
#     #  
#     #  # 用户搜索标签！！！！？？
#   end

#   describe '【管理员】' do 
#     # 编辑固定标签
#     admin_attrs = FactoryGirl.attributes_for(:admin)

#     header "X-Admin-Token", admin_attrs[:authentication_token]
#     header "X-Admin-Email", admin_attrs[:email]

#     get 'admin/constant_tags' do
#       parameter :class_name, '标签类型', required: false

#       example '管理员 获取所有 固定标签（ 默认为衣服标签 ）' do
#         do_request
#         puts response_body
#         expect(status).to eq(200)
#       end
#     end

#     post 'admin/constant_tags' do
#       parameter :title, '标签名', required: true, scope: :constant_tag
#       parameter :class_type, '标签类型', required: true, scope: :constant_tag

#       let(:title) { '新创建标签' } 
#       let(:class_type) { 'garment' } 

#       example '管理员 创建 固定标签' do
#         do_request
#         puts response_body
#         expect(status).to eq(201)
#       end
#     end

#     put 'admin/constant_tags/:id' do
#       parameter :title, '标签名', required: true, scope: :constant_tag
#       parameter :class_type, '标签类型', required: true, scope: :constant_tag

#       let(:title) { '新修改标签' } 
#       let(:class_type) { 'garment' } 
#       let(:id) { @constants.first.id } 

#       example '管理员 修改 固定标签' do
#         do_request
#         puts response_body
#         expect(status).to eq(201)
#       end
#     end

#     delete 'admin/constant_tags/:id' do

#       let(:id) { @constants.first.id } 

#       example '管理员 删除指定固定标签' do
#         do_request
#         puts response_body
#         expect(status).to eq(204)
#       end
#     end
#   end
# end