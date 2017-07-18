# == Schema Information
#
# Table name: service_orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  rent         :float
#  care_cost    :float
#  service_cost :float
#  operation    :string
#  remark       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_service_orders_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :service_order do
    rent 400
    care_cost 300
    service_cost 200
  end
end
