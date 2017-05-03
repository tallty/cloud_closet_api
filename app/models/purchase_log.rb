# == Schema Information
#
# Table name: purchase_logs
#
#  id             :integer          not null, primary key
#  operation      :string(191)
#  payment_method :string(191)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_info_id   :integer
#  detail         :text(65535)
#  balance        :float(24)
#  amount         :float(24)
#  is_increased   :boolean
#  credit         :integer          default(0)
#  actual_amount  :float(24)        default(0.0)
#  can_arrears    :boolean
#
# Indexes
#
#  index_purchase_logs_on_user_info_id  (user_info_id)
#
# Foreign Keys
#
#  fk_rails_037d3ad690  (user_info_id => user_infos.id)
#

class PurchaseLog < ApplicationRecord
	belongs_to :user_info

	def change_output
		self.is_increased ?
			"+%.2f"%self.amount :
			"-%.2f"%self.amount
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

end
