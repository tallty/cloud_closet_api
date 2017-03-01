# == Schema Information
#
# Table name: store_methods
#
#  id         :integer          not null, primary key
#  title      :string
#  zh_title   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :store_method do
    sequence(:title, 0) { |n| ['hanging', 'stacking', 'full_dress'][n] }
    sequence(:zh_title, 0) { |n| ['挂件', '叠放件', '礼服'][n] }
  end
end
