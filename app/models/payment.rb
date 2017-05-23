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

class Payment < Bill
	
		
end
