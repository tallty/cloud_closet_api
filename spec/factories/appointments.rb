# == Schema Information
#
# Table name: appointments
#
#  id                 :integer          not null, primary key
#  address            :string
#  name               :string
#  phone              :string
#  number             :integer
#  date               :date
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seq                :string
#  aasm_state         :string
#  price              :float            default(0.0)
#  detail             :string
#  remark             :text
#  care_type          :string
#  care_cost          :float
#  service_cost       :float
#  rent_charge        :float
#  garment_count_info :string
#  hanging_count      :integer          default(0)
#  stacking_count     :integer          default(0)
#  full_dress_count   :integer          default(0)
#  number_alias       :string
#  created_by_admin   :boolean
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :appointment do
    address "黄浦区济南路260号12栋603号"
    name "王先生"
    phone "18617671987"
    number 50
    date "2016-09-24"
    care_cost 111
    care_type '普通护理'
    service_cost 222
    number_alias '10-20件'
    # detail "衣服*2"
  end
end
