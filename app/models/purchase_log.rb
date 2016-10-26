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
#
# Indexes
#
#  index_purchase_logs_on_user_info_id  (user_info_id)
#

class PurchaseLog < ApplicationRecord
	belongs_to :user_info
	after_save :cut_payment

	def balance
		"%.2f"%self.user_info.balance
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
		self.user_info.balance  += self.change unless self.operation_type == "发票"
	end
end
