# == Schema Information
#
# Table name: exhibition_chests
#
#  id                 :integer          not null, primary key
#  exhibition_unit_id :integer
#  custom_title       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  aasm_state         :string
#
# Indexes
#
#  index_exhibition_chests_on_exhibition_unit_id  (exhibition_unit_id)
#

require 'rails_helper'

RSpec.describe ExhibitionChest, type: :model do
  it { should have_many(:garments) }
  it { should belong_to(:valuation_chest) }
  it { should belong_to(:exhibition_unit) }
end
