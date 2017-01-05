# == Schema Information
#
# Table name: chest_items
#
#  id         :integer          not null, primary key
#  chest_id   :integer
#  garment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chest_items_on_chest_id    (chest_id)
#  index_chest_items_on_garment_id  (garment_id)
#

FactoryGirl.define do
  factory :chest_item do
    sequence(:chest_id) { |n| "#{n}" }
    sequence(:garment_id) { |n| "#{n}" }
  end
end
