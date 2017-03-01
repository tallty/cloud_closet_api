# == Schema Information
#
# Table name: exhibition_units
#
#  id              :integer          not null, primary key
#  title           :string
#  store_method    :integer
#  max_count       :integer
#  need_join       :boolean
#  price_system_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exhibition_units_on_price_system_id  (price_system_id)
#

FactoryGirl.define do
  factory :exhibition_unit do
    title "MyString"
    store_method 1
    max_count 1
    need_join false
    price_system nil
  end
end
