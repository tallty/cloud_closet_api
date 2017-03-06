FactoryGirl.define do
  factory :garment_tag, class: :constant_tag do
    title_ary = ['上衣', '半裙', '连衣裙', '裤装', '外套', '羽绒服', '泳装']
    sequence(:title, 0) { |n| title_ary[n % title_ary.count] }
    class_type 'garment'
  end
end
