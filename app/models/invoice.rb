# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  title           :string(191)
#  amount          :float(24)
#  invoice_type    :string(191)
#  aasm_state      :string(191)
#  cel_name        :string(191)
#  cel_phone       :string(191)
#  postcode        :string(191)
#  address         :string(191)
#  date            :date
#  remaining_limit :float(24)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_invoices_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_3d1522a0d8  (user_id => users.id)
#

class Invoice < ApplicationRecord
	belongs_to :user
	before_save :set_remaining_limit
	after_save :send_msg, if: :aasm_state_changed?

	include AASM

	aasm do
    state :waiting
    state :accepted, :initial => true
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

		def send_msg
			# aasm_state
		end
end
