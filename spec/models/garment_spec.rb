# == Schema Information
#
# Table name: garments
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  title               :string
#  put_in_time         :datetime
#  expire_time         :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  seq                 :string
#  row                 :integer
#  carbit              :integer
#  place               :integer
#  aasm_state          :string           default("storing")
#  status              :string
#  store_method        :string
#  appointment_id      :integer
#  exhibition_chest_id :integer
#  description         :text
#
# Indexes
#
#  index_garments_on_appointment_id       (appointment_id)
#  index_garments_on_exhibition_chest_id  (exhibition_chest_id)
#  index_garments_on_seq                  (seq)
#  index_garments_on_user_id              (user_id)
#

require 'rails_helper'

RSpec.describe Garment, type: :model do
  it { should belong_to(:user) } 
  it { should have_one(:cover_image) } 
  3.times do |i|
  	eval("it { should have_one(:detail_image_#{ i +1 }) }")
  end
end
