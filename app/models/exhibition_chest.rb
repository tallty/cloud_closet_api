# == Schema Information
#
# Table name: exhibition_chests
#
#  id                       :integer          not null, primary key
#  exhibition_unit_id       :integer
#  custom_title             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  aasm_state               :string
#  valuation_chest_id       :integer
#  appointment_new_chest_id :integer
#  user_id                  :integer
#
# Indexes
#
#  index_exhibition_chests_on_appointment_new_chest_id  (appointment_new_chest_id)
#  index_exhibition_chests_on_exhibition_unit_id        (exhibition_unit_id)
#  index_exhibition_chests_on_user_id                   (user_id)
#  index_exhibition_chests_on_valuation_chest_id        (valuation_chest_id)
#

class ExhibitionChest < ApplicationRecord
  belongs_to :exhibition_unit
  belongs_to :valuation_chest
  belongs_to :user
  belongs_to :appointment_new_chest
  
  has_many :garments

  delegate :title, :store_method, :max_count, 
    :need_join, :price_system_id, to: :exhibition_unit#, allow_nil: false

  include AASM

  aasm do 
  	state :waiting, :initial => true
    state :online
    event :release do 
      transitions from: [:waiting, :online], to: :online
    end
	end

  def state
    I18n.t :"exhibition_chest_aasm_state.#{aasm_state}"
  end

  scope :has_space, ->{
    select{ |chest| chest.has_space? }
   }

  def remain_space_count
    _remain_space_count = self.max_count - self.garments.count    
  end

  def has_space?
    remain_space_count > 0
  end

  def enough_space_to_move
    # garments.stored
  end
end
