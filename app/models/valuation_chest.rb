# == Schema Information
#
# Table name: valuation_chests
#
#  id                         :integer          not null, primary key
#  price_system_id            :integer
#  aasm_state                 :string
#  user_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  start_time                 :date
#  appointment_price_group_id :integer
#
# Indexes
#
#  index_valuation_chests_on_appointment_price_group_id  (appointment_price_group_id)
#  index_valuation_chests_on_price_system_id             (price_system_id)
#  index_valuation_chests_on_user_id                     (user_id)
#

class ValuationChest < ApplicationRecord
  belongs_to :price_system
  belongs_to :user
  belongs_to :appointment_price_group
  
  has_many :exhibition_chests
  
  after_create :create_relate_exhibition_chests
  
  delegate :title, :price, to: :price_system#, allow_nil: true

  # use unscope to cancel it
  default_scope { where("aasm_state not like 'deleted'") }

	include AASM

  aasm do 
  	state :using, :initial => true
    state :deleted
    event :soft_delete do 
      transitions from: :using, to: :deleted, :after => :soft_delete_his_exhi_chest
    end
	end

  private
    def soft_delete_his_exhi_chest
      self.exhibition_chests.each {|i| i.soft_delete!}
    end

    def create_relate_exhibition_chests
      self.price_system.exhibition_units.each do |exhibition_unit| 
        _exhibition_chest = self.exhibition_chests.build(
          exhibition_unit: exhibition_unit,
          user: self.user,
          expiring_time: Time.zone.now + self.appointment_price_group.store_month.months
        )
        raise '用户展示衣柜创建失败' unless _exhibition_chest.save
      end
    end

end
