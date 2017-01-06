# == Schema Information
#
# Table name: appointment_items
#
#  id                        :integer          not null, primary key
#  garment_id                :integer
#  appointment_id            :integer
#  store_month               :integer
#  price                     :float
#  status                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  appointment_item_group_id :integer
#  aasm_state                :string           default("storing")
#
# Indexes
#
#  index_appointment_items_on_appointment_id             (appointment_id)
#  index_appointment_items_on_appointment_item_group_id  (appointment_item_group_id)
#  index_appointment_items_on_garment_id                 (garment_id)
#

class AppointmentItem < ApplicationRecord
	include AASM
  	belongs_to :garment
  	belongs_to :appointment
  	belongs_to :appointment_item_group

  	before_create :create_relate_garment

  	# enum status: {
  	# 	unstore: 0, ###!!!
   # 		storing: 1,
   # 		stored: 2
  	# }
      
   #    aasm :column => :status, :enum => true do
   #      state :storing, :initial => true
   #      state :stored

   #      event :finish_storing do
   #        transitions :from => :storing, :to => :stored
   #      end
   #    end

  	# def item_status
  	# 	I18n.t :"appointment_itme_status.#{status}"
  	# end

  	private
    	def create_relate_garment
      		garment = Garment.create(user: self.appointment.try(:user))
      		self.garment = garment
      		# self.success!
    	end
end
