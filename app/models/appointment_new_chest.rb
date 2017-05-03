# == Schema Information
#
# Table name: appointment_new_chests
#
#  id                         :integer          not null, primary key
#  appointment_price_group_id :integer
#  appointment_id             :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  exhibition_unit_id         :integer
#
# Indexes
#
#  index_appointment_new_chests_on_appointment_id              (appointment_id)
#  index_appointment_new_chests_on_appointment_price_group_id  (appointment_price_group_id)
#  index_appointment_new_chests_on_exhibition_unit_id          (exhibition_unit_id)
#
# Foreign Keys
#
#  fk_rails_2d7ebd729b  (appointment_price_group_id => appointment_price_groups.id)
#  fk_rails_5bd8d3c674  (appointment_id => appointments.id)
#

class AppointmentNewChest < ApplicationRecord
  belongs_to :appointment # need?
  belongs_to :appointment_price_group

  belongs_to :exhibition_unit
  has_one :exhibition_chest
 	
  delegate :user, to: :appointemnt, allow_nil: false # right?
  delegate :title, :store_method, :max_count, :need_join, :price_system_id, to: :exhibition_unit
 	after_create :create_relate_chest

 	private
 		def create_relate_chest
 			raise '用户错误' unless _user = self.appointment_price_group.appointment.try(:user)
 			_exhibition_chest = _user.exhibition_chests.build(
 					exhibition_unit: self.exhibition_unit,
 					appointment_new_chest: self,
 					valuation_chest: self.appointment_price_group.valuation_chest
 				)
 			raise '用户展示衣柜创建失败' unless _exhibition_chest.save

 		end
end
