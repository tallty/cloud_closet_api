# == Schema Information
#
# Table name: chest_items
#
#  id         :integer          not null, primary key
#  chest_id   :integer
#  garment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chest_items_on_chest_id    (chest_id)
#  index_chest_items_on_garment_id  (garment_id)
#

require 'rails_helper'

RSpec.describe ChestItem, type: :model do
  it { should belong_to(:garment) } 
  it { should belong_to(:chest) } 
end
