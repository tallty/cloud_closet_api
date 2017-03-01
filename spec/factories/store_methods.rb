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
    title "MyString"
    zh_title "MyString"
  end
end
