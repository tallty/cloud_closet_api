# == Schema Information
#
# Table name: purchase_logs
#
#  id             :integer          not null, primary key
#  operation      :string
#  payment_method :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_info_id   :integer
#  detail         :text
#  balance        :float
#  amount         :float
#  is_increased   :boolean
#
# Indexes
#
#  index_purchase_logs_on_user_info_id  (user_info_id)
#

require 'rails_helper'

RSpec.describe PurchaseLog, type: :model do
  it { should belong_to(:user_info) } 
end
