# == Schema Information
#
# Table name: garments
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string
#  put_in_time :datetime
#  expire_time :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  seq         :string
#  row         :integer
#  carbit      :integer
#  place       :integer
#  aasm_state  :string
#  status      :string
#
# Indexes
#
#  index_garments_on_seq      (seq)
#  index_garments_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Garment, type: :model do
  it { should belong_to(:user) } 
  it { should have_one(:cover_image) }  
  it { should have_many(:logs) } 
  it { should have_one(:detail_image_1) }
  it { should have_one(:detail_image_2) }
  it { should have_one(:detail_image_3) }
end
