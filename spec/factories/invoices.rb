# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  title           :string
#  amount          :float
#  invoice_type    :string
#  aasm_state      :string
#  cel_name        :string
#  cel_phone       :string
#  postcode        :string
#  address         :string
#  date            :date
#  remaining_limit :float
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_invoices_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :invoice do
    title 'aaa'
    amount 200.00
    invoice_type "我是普通发票"
    cel_name "我是联系人姓名"
    cel_phone "我是联系人电话"
    postcode "我是邮政编码"
    address "我是地址"
    date "2017-03-20"
  end
end
