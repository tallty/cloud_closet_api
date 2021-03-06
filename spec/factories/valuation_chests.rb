# == Schema Information
#
# Table name: valuation_chests
#
#  id                         :integer          not null, primary key
#  price_system_id            :integer
#  aasm_state                 :string
#  user_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  start_time                 :date
#  appointment_price_group_id :integer
#
# Indexes
#
#  index_valuation_chests_on_appointment_price_group_id  (appointment_price_group_id)
#  index_valuation_chests_on_price_system_id             (price_system_id)
#  index_valuation_chests_on_user_id                     (user_id)
#

FactoryGirl.define do
  factory :valuation_chest do
  end
end
