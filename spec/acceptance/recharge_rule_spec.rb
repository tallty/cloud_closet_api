# require 'acceptance_helper'

# resource '充值规则 相关' do
#   header 'Accept', 'application/json'

#   before do
#     create_list(:recharge_rule, 5)
#   end

#   get '/recharge_rules' do

#     example '获取 所有充值规则 成功' do
#       do_request
#       puts response_body
#       expect(status).to eq(200)
#     end
#   end


#   describe '【管理员】' do 
#     # 暂缓
#     # example '管理员 创建充值规则' do
#     #   do_request
#     #   puts response_body
#     #   expect(status).to eq(200)
#     # end
#   end
# end