# == Schema Information
#
# Table name: chests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  appointment_id :integer
#  classify       :integer
#  surplus        :integer
#  description    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  price          :float            default(0.0)
#
# Indexes
#
#  index_chests_on_appointment_id  (appointment_id)
#  index_chests_on_user_id         (user_id)
#

FactoryGirl.define do
  factory :chest do
    sequence(:user_id) { |n| "#{n}" }
    sequence(:appointment_id) { |n| "#{n}" }
    classify "hang_chest"
  end
end
