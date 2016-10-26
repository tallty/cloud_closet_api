# == Schema Information
#
# Table name: purchase_logs
#
#  id             :integer          not null, primary key
#  type           :string
#  operation      :string
#  change         :float
#  payment_method :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PurchaseLog < ApplicationRecord
end
