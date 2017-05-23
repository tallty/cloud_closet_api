# == Schema Information
#
# Table name: offline_recharges
#
#  id           :integer          not null, primary key
#  amount       :float
#  credit       :integer
#  is_confirmed :boolean
#  worker_id    :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_offline_recharges_on_user_id    (user_id)
#  index_offline_recharges_on_worker_id  (worker_id)
#

class OfflineRecharge < ApplicationRecord
	belongs_to :user
	belongs_to :worker
	validate :ckeck_auth_code, on: :create
	after_create :create_purchase_log

	attr_accessor :auth_code
	
	def user_phone
		user.phone
	end

	def user_name 
		user.info.nickname
	end

	def worker_phone
		worker.phone
	end

	private
		def ckeck_auth_code
			SmsToken.offline_recharge_code_auth_validate?(self)
		end

		def create_purchase_log
			PurchaseLogService.new(
					self.user, ['offline_recharge', 'credit'],
					{
						offline_recharge: self
					}
				).create
		end
end

