# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  title           :string
#  amount          :float
#  invoice_type    :string
#  aasm_state      :string
#  cel_name        :string
#  cel_phone       :string
#  postcode        :string
#  address         :string
#  date            :date
#  remaining_limit :float
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_invoices_on_user_id  (user_id)
#

class Invoice < ApplicationRecord
	belongs_to :user
	
	before_save :set_remaining_limit
	after_create :send_sms_to_worker
	after_save :send_wechat_msg, if: :aasm_state_changed?
	
	include AASM

	aasm do
    state :waiting, :initial => true
    state :accepted
    state :refused, :had_been_send

    event :accept do
      transitions from: :waiting, to: :accepted
    end

    event :send_out do 
    	transitions from: :accepted, to: :had_been_send
    end

    event :refuse do
      transitions from: :waiting, to: :refused
    end
  end

  def state
  	I18n.t :"invoice_aasm_state.#{aasm_state}"
  end

	private
		def set_remaining_limit
			user_info = self.user.info

			raise '开票额度不足' if (user_info.recharge_amount -= self.amount) < 0
			self.remaining_limit = 
				user_info.recharge_amount if user_info.save!
		end

		def send_wechat_msg
			# aasm_state
		end

		def send_sms_to_worker
			SmsService.new('worker').new_invoice(self)
		end
end
