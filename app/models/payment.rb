# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  amount     :decimal(10, )
#  bill_type  :integer          default("deposit")
#  seq        :string(191)
#  sign       :string(191)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bills_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_f5fcc78f42  (user_id => users.id)
#

class Payment < Bill
	
		
end
