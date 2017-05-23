# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  amount     :decimal(, )
#  bill_type  :integer          default("deposit")
#  seq        :string
#  sign       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bills_on_user_id  (user_id)
#

class Bill < ApplicationRecord
  belongs_to :user

  ############ validates #################
  validates :amount, numericality: { greater_than_or_equal_to: 0.00 }
  after_create :bill_seq
  ######## enum_state #######
  enum bill_type: {
  	 deposit: 0,
  	 payment: 1
  }
  ########### where-bills ########
  scope :state_bill,->(num){ where(bill_type:num)}
  ############ surpplus ##########
  def bill_surplus
  	if self.bill_type.present? && self.bill_type == 0
  	  bills = Bill.all.state_bill(0)
  		deposit_amounts = bills.to_a.sum { |bill| bill.amount }
  	elsif self.bill_type.present? && self.bill_type == 0
  		bills = Bill.all.state_bill(1)
  		payment_amounts = bills.to_a.sum { |bill| bill.amount }	
  	end
    deposit_amounts.to_f - payment_amounts.to_f
  end
  ############## bills_record #########
  def self.deposit_record
  	  self.state_bill(0)
  end
  
  def self.payment_record
  	  self.state_bill(1)
  end
  
  private
    ############## bill_seq ############
    def bill_seq
      self.seq = "B#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end
end
