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

  # use unscope to cancel it
  default_scope { where("aasm_state not like 'deleted'") }

  aasm do 
  	state :waiting, :initial => true
    state :online, :deleted
    event :release do 
      transitions from: [:waiting, :online], to: :online, :after => :release_new_garments
    end

    event :soft_delete do 
      transitions from: :online, to: :deleted
    end

	end

  def state
    I18n.t :"exhibition_chest_aasm_state.#{aasm_state}"
  end

  scope :has_space, ->{
    select{ |chest| chest.it_has_space }
   }

  scope :store_method_is, ->(store_method){
     select {|chest| chest.store_method == store_method}
   }

  scope :those_buddies_need_join_by, -> (it){ 
    where( user: it.user ).where( 
      exhibition_unit: it.exhibition_unit
      )
    }

  include ExhibitionChestSpaceInfo

  def his_duddies_can_be_break?
    self.valuation_chest.exhibition_chests.collect(&:garments).reduce(:+).select{ |garment| garment.stored?}.blank?
  end

  def delete_his_val_chest
    raise '绑定衣柜中仍有衣服，不能释放该衣柜'  unless   his_duddies_can_be_break? 
    self.valuation_chest.soft_delete! 
  end

  def move_garment
    
  end

  def enough_space_to_move
    # garments.stored
  end

  def release_new_garments
    ActiveRecord::Base.transaction do
      self.garments.each { |garment| garment.finish_storing! }
    end
  end
end
