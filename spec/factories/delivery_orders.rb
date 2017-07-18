# == Schema Information
#
# Table name: delivery_orders
#
#  id              :integer          not null, primary key
#  address         :string
#  name            :string
#  phone           :string
#  delivery_time   :date
#  delivery_method :string
#  remark          :string
#  delivery_cost   :integer
#  service_cost    :integer
#  aasm_state      :string
#  garment_ids     :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  seq             :string
#
# Indexes
#
#  index_delivery_orders_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :delivery_order do
    address "我是 地址"
    name "我是 联系人"
    phone "我是 联系人电话"
    delivery_time "2017-04-14"
    delivery_method "我是 配送方式"
    remark "我是 备注 备注 备注 ..."
    delivery_cost 100
    service_cost 200
  end
end
