# == Schema Information
#
# Table name: service_orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  rent         :float
#  care_cost    :float
#  service_cost :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_service_orders_on_user_id  (user_id)
#

class ServiceOrder < ApplicationRecord
  have_many :appointment_price_group
end
