# == Schema Information
#
# Table name: appointment_price_groups
#
#  id              :integer          not null, primary key
#  price_system_id :integer
#  appointment_id  :integer
#  count           :integer
#  store_month     :integer
#  unit_price      :float
#  price           :float
#  is_chest        :boolean
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_appointment_price_groups_on_appointment_id   (appointment_id)
#  index_appointment_price_groups_on_price_system_id  (price_system_id)
#

require 'rails_helper'

RSpec.describe AppointmentPriceGroup, type: :model do
	it { should belong_to(:appointment) } 
	it { should belong_to(:price_system) } 
	it { should have_many(:valuation_chest)} do
		
	end
end
