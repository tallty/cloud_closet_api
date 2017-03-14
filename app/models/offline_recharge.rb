# == Schema Information
#
# Table name: offline_recharges
#
#  id           :integer          not null, primary key
#  amount       :float
#  credit       :float
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
end

