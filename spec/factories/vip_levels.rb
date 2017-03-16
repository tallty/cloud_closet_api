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

    name_ary = [ '普通会员', '银卡会员', '金卡会员', '砖石卡会员' ]
    exp_ary = [ 0, 800, 6000, 20000 ]
    sequence(:name, 0) { |n| name_ary[n % name_ary.count] }
    sequence(:exp, 0) { |n| exp_ary[n % exp_ary.count] }
    sequence(:rank, 0) { |n| n }
  end
end
