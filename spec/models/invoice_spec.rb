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

require 'rails_helper'

RSpec.describe Invoice, type: :model do
	it { should belong_to(:user)}
end
