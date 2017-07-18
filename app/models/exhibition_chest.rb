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
#  expire_time              :datetime
#  max_count                :integer
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

  delegate :title, :store_method,
    :need_join, :price_system_id, to: :exhibition_unit#, allow_nil: false

  include AASM

  # use unscope to cancel it
  default_scope { where.not(aasm_state: 'deleted') }

  aasm do 
  	state :online, :initial => true
    state :waiting, :online, :deleted
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

  def max_count
    read_attribute(:max_count) || self.exhibition_unit.max_count
  end

  def custom_title
    read_attribute(:custom_title) || title
  end

  def is_expired
    expire_time < Time.zone.now
  end

  def is_about_to_expire
    expire_time < Time.zone.now + 1.month
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
  scope :about_to_expire, ->{
    select{ |chest| chest.is_about_to_expire }
  }

  include ExhibitionChestSpaceInfo

  def lease_renewal month
    month = month.to_i
    raise '月份必须为正整数' unless month > 0
    ActiveRecord::Base.transaction do
      # 组合柜将一起延期
      _chests = valuation_chest.exhibition_chests
      # 创建订单
      appt_params = {
          remark: "#{_chests.map(&:custom_title).reject(&:blank?).join('与')}续租#{month}月",
          meta: { 
            lease_renewal_chest_id: self.id,
            month: month
          }
      }
      appt_group_params = {
        price_groups: [
          {
            price_system: valuation_chest.price_system,
            count: 1,
            store_month: month
          }
        ]
      }
      appt = Appointment.create_by_admin(user, appt_params, appt_group_params)
    end
  end

  def his_duddies_can_be_break?
    self.valuation_chest.exhibition_chests.collect(&:garments).reduce(:+).select{ |garment| 
      garment.status.in?(['stored', ':in_basket', 'delivering'])
      # 存在配送中的衣服，可能会退回，此时亦不能删除衣柜
    }.blank?
  end

  def delete_his_val_chest
    raise '绑定衣柜中仍有衣服，不能释放该衣柜' unless his_duddies_can_be_break? 
    ActiveRecord::Base.transaction do
      self.valuation_chest.soft_delete! 
      self.soft_delete!
    end
  end

  def release_new_garments
    ActiveRecord::Base.transaction do
      self.garments.each { |garment| garment.finish_storing! }
    end
  end
end
