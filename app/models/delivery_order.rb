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
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_delivery_orders_on_user_id  (user_id)
#

class DeliveryOrder < ApplicationRecord
  belongs_to :user
end
