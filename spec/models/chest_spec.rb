# == Schema Information
#
# Table name: chests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  appointment_id :integer
#  classify       :integer
#  surplus        :integer
#  description    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  price          :float            default(0.0)
#
# Indexes
#
#  index_chests_on_appointment_id  (appointment_id)
#  index_chests_on_user_id         (user_id)
#

require 'rails_helper'

RSpec.describe Chest, type: :model do
  it { should belong_to(:appointment) } 
  it { should belong_to(:user) } 
  it { should have_many(:items) } 
end
