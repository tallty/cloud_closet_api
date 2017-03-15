# == Schema Information
#
# Table name: ping_requests
#
#  id          :integer          not null, primary key
#  object_type :string
#  ping_id     :string
#  complete    :boolean
#  amount      :integer
#  subject     :string
#  body        :string
#  client_ip   :string
#  extra       :string
#  order_no    :string
#  channel     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  openid      :string
#  metadata    :string
#  credit      :integer
#  user_id     :integer
#
# Indexes
#
#  index_ping_requests_on_user_id  (user_id)
#

class PingRequest < ApplicationRecord

  belong_to :user
	
  def get_pay_order  extra
	  Pingpp::Charge.create(
      :order_no  => self.order_no,
      :app       => { :id => APP_ID },
      :channel   => self.channel, #'wx_pub',
      #!!!### 临时充值为 0.01 元 ###########
      :amount    => 1, #self.amount,
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
