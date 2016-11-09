# == Schema Information
#
# Table name: appointment_items
#
#  id                        :integer          not null, primary key
#  garment_id                :integer
#  appointment_id            :integer
#  store_month               :integer
#  price                     :float
#  status                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  appointment_item_group_id :integer
#  aasm_state                :string
#
# Indexes
#
#  index_appointment_items_on_appointment_id             (appointment_id)
#  index_appointment_items_on_appointment_item_group_id  (appointment_item_group_id)
#  index_appointment_items_on_garment_id                 (garment_id)
#

require 'rails_helper'

RSpec.describe AppointmentItem, type: :model do
  it { should belong_to(:garment) } 
  it { should belong_to(:appointment) } 
end
