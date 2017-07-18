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

require 'rails_helper'

RSpec.describe DeliveryOrder, type: :model do
  it { should belong_to :user }
end
