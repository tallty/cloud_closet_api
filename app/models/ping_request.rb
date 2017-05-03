# == Schema Information
#
# Table name: ping_requests
#
#  id          :integer          not null, primary key
#  object_type :string(191)
#  ping_id     :string(191)
#  complete    :boolean
#  amount      :integer
#  subject     :string(191)
#  body        :string(191)
#  client_ip   :string(191)
#  extra       :string(191)
#  order_no    :string(191)
#  channel     :string(191)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  openid      :string(191)
#  metadata    :string(191)
#  credit      :integer
#  user_id     :integer
#
# Indexes
#
#  index_ping_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_a1cd59727f  (user_id => users.id)
#

class PingRequest < ApplicationRecord
  # 注 ： amount 转化为实际金额需要 * 0.01

  belongs_to :user
	
  def get_pay_order  extra
	  Pingpp::Charge.create(
      :order_no  => self.order_no,
      :app       => { :id => APP_ID },
      :channel   => self.channel, #'wx_pub',
      #!!!### 临时充值为 0.01 元 ###########
      :amount    => self.amount,
      ################################
      :client_ip => self.client_ip, #Pingplusplus.new.get_client_id,
      :currency  => "cny",
      :subject   => self.subject,
      :body      => self.body,
      :extra     => extra, #直接从数据库去除的是一个字符串 需要解成 hash
      :metadata  => self.metadata ? JSON.parse(self.metadata) : {}
       ) 
	end

  def self.create_order_no #order_no 允许重复
    chars =  ('1'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    Array.new(8).collect{chars[rand(chars.size - 1)]}.join 
  end
    


end
