# == Schema Information
#
# Table name: constant_tags
#
#  id         :integer          not null, primary key
#  title      :string
#  class_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :garment_tag, class: :constant_tag do
    title_ary = ['上衣', '半裙', '连衣裙']
    sequence(:title, 0) { |n| title_ary[n % title_ary.count] }
    class_type 'garment'
  end
end
