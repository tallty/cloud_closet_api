# == Schema Information
#
# Table name: exhibition_chests
#
#  id                 :integer          not null, primary key
#  exhibition_unit_id :integer
#  custom_title       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_exhibition_chests_on_exhibition_unit_id  (exhibition_unit_id)
#

class ExhibitionChest < ApplicationRecord
  belongs_to :exhibition_unit
  has_one :appointment_new_chest
  has_many :garment
end
