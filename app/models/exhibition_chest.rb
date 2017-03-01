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
#  valuation_chest_id :integer
#
# Indexes
#
#  index_exhibition_chests_on_exhibition_unit_id  (exhibition_unit_id)
#  index_exhibition_chests_on_valuation_chest_id  (valuation_chest_id)
#

class ExhibitionChest < ApplicationRecord
  belongs_to :exhibition_unit
  belongs_to :valuation_chest
  
  has_one :appointment_new_chest
  has_many :garments

  delegate :store_method, :max_count, :need_join, to: :exhibition_unit#, allow_nil: true

  include AASM

  aasm do 
  	state :aaa, :initial => true
	end
end
