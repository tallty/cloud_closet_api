# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  address    :string
#  name       :string
#  phone      :string
#  number     :integer
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  seq        :string
#  aasm_state :string
#  price      :float            default(0.0)
#  detail     :string
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
    price	"100.00"
    detail "衣服*2"
  end
end
