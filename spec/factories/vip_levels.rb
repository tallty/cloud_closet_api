# == Schema Information
#
# Table name: vip_levels
#
#  id            :integer          not null, primary key
#  name          :string
#  xp            :integer
#  birthday_gift :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rank          :integer
#

FactoryGirl.define do
  factory :vip_level do
    name "MyString"
    xp 1
    birthday_gift 1
  end
end
