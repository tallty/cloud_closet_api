# == Schema Information
#
# Table name: appointment_new_chests
#
#  id                         :integer          not null, primary key
#  exhibition_chest_id        :integer
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
#  index_appointment_new_chests_on_exhibition_chest_id         (exhibition_chest_id)
#  index_appointment_new_chests_on_exhibition_unit_id          (exhibition_unit_id)
#

class AppointmentNewChest < ApplicationRecord
  belongs_to :appointment
  belongs_to :appointment_price_group
  belongs_to :exhibition_chest
  belongs_to :exhibition_unit
 	
  delegate :user, to: :appointemnt, allow_nil: false # right?

 	before_create :create_relate_chest

 	private
 		def create_relate_chest
 			raise '用户错误' unless _user = self.appointment.try(:user)
 			_user.exhibition_chests.build(
 					exhibition_unit: self.exhibition_unit,
 					
 				)

 			
 		end
end
