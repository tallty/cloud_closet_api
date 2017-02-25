# == Schema Information
#
# Table name: appointment_item_groups
#
#  id              :integer          not null, primary key
#  count           :integer
#  appointment_id  :integer
#  store_month     :integer
#  price           :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type_name       :string
#  season          :string
#  price_system_id :integer
#  chest_id        :integer
#
# Indexes
#
#  index_appointment_item_groups_on_appointment_id   (appointment_id)
#  index_appointment_item_groups_on_chest_id         (chest_id)
#  index_appointment_item_groups_on_price_system_id  (price_system_id)
#

require 'rails_helper'

RSpec.describe AppointmentItemGroup, type: :model do
  it { should belong_to(:appointment) } 
  it { should have_many(:items) } 
  it { should have_many(:garments).through(:items) } 
end
