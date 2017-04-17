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

  include AASM

  aasm do 
  	state :unpaid, initial: true
  	state :paid, :canceled, :delivering, :finished

    event :pay do
      transitions from: :unpaid, to: :paid, after:  :after_pay
    end

    event :cancel do
      transitions from: :unpaid, to: :canceled
    end

    event :admin_send_it_out do
      transitions from: :paid, to: :delivering
    end

    event :user_got_it do
      transitions from: :delivering, to: :finished
    end
	end

end
