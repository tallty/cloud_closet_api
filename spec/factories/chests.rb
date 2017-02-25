# == Schema Information
#
# Table name: chests
#
#  id                     :integer          not null, primary key
#  title                  :string
#  chest_type             :string
#  max_count              :integer
#  user_id                :integer
#  price_system_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  end_day                :date
#  start_day              :date
#  last_time_inc_by_month :integer
#  aasm_state             :string
#
# Indexes
#
#  index_chests_on_price_system_id  (price_system_id)
#  index_chests_on_user_id          (user_id)
#

FactoryGirl.define do
  factory :chest do
    title "MyString"
    chest_type "MyString"
    max_count 1
    user nil
  end
end
