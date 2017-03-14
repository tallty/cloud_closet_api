# == Schema Information
#
# Table name: offline_recharges
#
#  id         :integer          not null, primary key
#  amount     :float
#  credit     :float
#  worker_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_offline_recharges_on_user_id    (user_id)
#  index_offline_recharges_on_worker_id  (worker_id)
#

FactoryGirl.define do
  factory :offline_recharge do
    amount 1000
    credit 200
  end
end
