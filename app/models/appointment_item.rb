# == Schema Information
#
# Table name: appointment_items
#
#  id                        :integer          not null, primary key
#  garment_id                :integer
#  appointment_id            :integer
#  store_month               :integer
#  price                     :float(24)
#  status                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  appointment_item_group_id :integer
#  aasm_state                :string(191)      default("storing")
#  store_mode                :string(191)
#
# Indexes
#
#  index_appointment_items_on_appointment_id             (appointment_id)
#  index_appointment_items_on_appointment_item_group_id  (appointment_item_group_id)
#  index_appointment_items_on_garment_id                 (garment_id)
#
# Foreign Keys
#
#  fk_rails_989306b84d  (appointment_id => appointments.id)
#  fk_rails_b5f15fb7fe  (garment_id => garments.id)
#  fk_rails_f01b3da157  (appointment_item_group_id => appointment_item_groups.id)
#

# 弃用
class AppointmentItem < ApplicationRecord
	# include AASM
 #  	belongs_to :garment
 #  	belongs_to :appointment
 #  	belongs_to :appointment_item_group

 #    # 出错在工作人员确认订单时而不在用户确认付款时 报错比较合理
 #  	before_create :create_relate_garment

 #  	private
 #    	def create_relate_garment
 #    		garment = Garment.create(user: self.appointment.try(:user), store_mode: self.store_mode)
 #    		self.garment = garment
 #    	end
end
