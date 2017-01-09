# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  bill_type  :integer          default(0)
#  seq        :string
#  sign       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :float            default(0.0)
#
# Indexes
#
#  index_bills_on_user_id  (user_id)
#

class Bill < ApplicationRecord
  belongs_to :user

  after_create :update_total_price
  after_create :bill_seq
  after_create :cut_payment 

  ######## enum_state #######
  # enum bill_type: {
  # 	 deposit: 0,
  # 	 payment: 1
  # }
  
  # ########### where-bills ########
  # scope :state_bill,->(num){ where(bill_type: num)}
  # ############ surpplus ##########
  # def bill_surplus
  # 	if self.bill_type.present? && self.bill_type == 0
  # 	  bills = Bill.all.state_bill(0)
  # 		deposit_amounts = bills.to_a.sum { |bill| bill.amount }
  # 	elsif self.bill_type.present? && self.bill_type == 0
  # 		bills = Bill.all.state_bill(1)
  # 		payment_amounts = bills.to_a.sum { |bill| bill.amount }	
  # 	end
  #   deposit_amounts.to_f - payment_amounts.to_f
  # end
  # ############## bills_record #########
  # def self.deposit_record
  # 	  self.state_bill(0)
  # end
  
  # def self.payment_record
  # 	  self.state_bill(1)
  # end

  ############## Bill_price#################
  def update_total_price
    self.price = 0.00 
    _chests = Chest.all.where(user_id: self.user_id)
    if _chests.present?
      _chests.each do |chest|
        _days = Time.days_in_month(Time.zone.now.month) - Time.zone.today.day #当天到月末的天数
        _day = Time.days_in_month(Time.zone.now.month) #本月的天数
        if _days < 29
          self.price += chest.price / _day
        else
          self.price += chest.price 
        end  
      end
    end
    self.save
  end

  ###############扣除用余额#################
  def cut_payment
    self.user.user_info.balance -= self.price  
    self.user.user_info.balance = self.user.user_info.balance.round(2)
    self.user.user_info.save
  end
  
  private
    ############## bill_seq ############
    def bill_seq
      self.seq = "B#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end
end
