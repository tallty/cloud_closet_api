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
#

class PingRequest < ApplicationRecord

	def get_pay_order  extra
	  Pingpp::Charge.create(
                          :order_no  => self.order_no,
                          :app       => { :id => APP_ID },
                          :channel   => self.channel, #'wx_pub',
                          :amount    => self.amount,
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

  def send_recharge_success_message balance
    openid = self.openid
    template = {
      template_id: "EJGMPFNSkgMee7o50EH0D1eOM3iawiNwjaSteThxex0",
      url: "http://closet.tallty.com/user",
      topcolor: "#FF0000",

      data: {
        first: {
          value: "充值成功",
          color: "#0A0A0A"
        },
        keyword1: {
          value: (self.amount.to_f/100).round(2),
          color: "#CCCCCC"
        },
        # keyword2: {
        #   value: "你是谁",
        #   color: "#CCCCCC"
        # },#赠送金额
        keyword3: {
          value: "乐存好衣",
          color: "#CCCCCC"
        },#充值门店
        keyword4: {
          value: balance,
          color: "#CCCCCC"
        },
        remark: {
          value: "如有疑问，敬请咨询：8888-8888888.",
          color: "#173177"
        }
      }
    }
    response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
      { openid: openid, template: template}
    puts response.body
  end

end
