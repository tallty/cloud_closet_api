# == Schema Information
#
# Table name: appointments
#
#  id                 :integer          not null, primary key
#  address            :string
#  name               :string
#  phone              :string
#  number             :integer
#  date               :date
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seq                :string
#  aasm_state         :string
#  price              :float            default(0.0)
#  detail             :string
#  remark             :text
#  care_type          :string
#  care_cost          :float
#  service_cost       :float
#  rent_charge        :float
#  garment_count_info :string
#  hanging_count      :integer          default(0)
#  stacking_count     :integer          default(0)
#  full_dress_count   :integer          default(0)
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it { should belong_to(:user) } 
  it { should have_many(:new_chests) } 
  it { should have_many(:groups) } 
end
