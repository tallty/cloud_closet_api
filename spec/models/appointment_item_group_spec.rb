# == Schema Information
#
# Table name: appointment_item_groups
#
#  id             :integer          not null, primary key
#  count          :integer
#  appointment_id :integer
#  store_month    :integer
#  price          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type_name      :string
#
# Indexes
#
#  index_appointment_item_groups_on_appointment_id  (appointment_id)
#

require 'rails_helper'

RSpec.describe AppointmentItemGroup, type: :model do
  it { should belong_to(:appointment) } 
  it { should have_many(:items) } 
  it { should have_many(:garments).through(:items) } 
end
