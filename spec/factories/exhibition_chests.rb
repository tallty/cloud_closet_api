# == Schema Information
#
# Table name: exhibition_chests
#
#  id                 :integer          not null, primary key
#  exhibition_unit_id :integer
#  custom_title       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  aasm_state         :string
#  valuation_chest_id :integer
#
# Indexes
#
#  index_exhibition_chests_on_exhibition_unit_id  (exhibition_unit_id)
#  index_exhibition_chests_on_valuation_chest_id  (valuation_chest_id)
#

FactoryGirl.define do
  factory :exhibition_chest do
    exhibition_unit nil
    custom_title "MyString"
  end
end
