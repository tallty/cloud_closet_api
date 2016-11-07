# == Schema Information
#
# Table name: purchase_logs
#
#  id             :integer          not null, primary key
#  operation_type :string
#  operation      :string
#  change         :float
#  payment_method :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_info_id   :integer
#  detail         :string
#  balance        :float
#
# Indexes
#
#  index_purchase_logs_on_user_info_id  (user_info_id)
#

class PurchaseLog < ApplicationRecord
	belongs_to :user_info
	after_create :cut_payment

	def self.create_one_with_ping_request _ping_request
		_metadata = _ping_request.metadata ? JSON.parse(_ping_request.metadata) : ""
		_channel = I18n.t :"pingpp_channel.#{_ping_request.channel}"

		PurchaseLog.create(
                operation_type: _ping_request.subject,
                operation: _ping_request.body,
                change: (_ping_request.amount.to_f/100).round(2),
                detail: _metadata['detail'] || "",
                user_info: User.where(openid: _ping_request.openid).first.user_info,
                payment_method: _channel
                )
		#现 不需要微信支付 		operation,deatil,metadata暂不需要
		#operation 购买衣橱 衣服配送  
		#detail 衣服*3 裤子*4
		#payment_method 微信支付
	end

	def self.create_one_with_storing_garment appointment
		PurchaseLog.create(
			operation: "购买衣橱",
			operation_type: "消费",
			change: appointment.price,
			detail: appointment.detail,
			user_info: appointment.user.user_info,
			payment_method: "余额支付"
			)
	end

	def change_output
		case self.operation_type
		when "充值"
			"+%.2f"%self.change
		when "发票"
			"%.2f"%self.change
		else #消费 提现 复数
			"%.2f"%self.change
		end
	end

	def date
		self.created_at.strftime("%Y-%m-%d")
	end

	def time
		self.created_at.strftime("%H:%M")
	end

	def what_day
			_x = Time.now - 1.day > self.created_at && self.created_at > Time.now - 2.day  ? "昨天" : self.created_at.wday.to_s
			_x = "今天" if self.created_at.day == Time.now.day
		case _x
		when "今天"
			["今天", self.time]
		when "昨天"
			["昨天", self.time]
		when "0"
			["周日", self.date]
		when "1"
			["周一", self.date]
		when "2"
			["周二", self.date]
		when "3"
			["周三", self.date]
		when "4"
			["周四", self.date]
		when "5"
			["周五", self.date]
		when "6"
			["周六", self.date]
		end
	end

	private

	def cut_payment
		self.user_info.balance += self.change if self.operation_type == "充值" || self.operation == "充值" 
		self.user_info.balance -= self.change if self.operation_type == "消费" || self.operation_type == "提现"
		self.user_info.balance = self.user_info.balance.round(2)
		self.user_info.save
		self.balance = self.user_info.balance
		self.save
	end
end
