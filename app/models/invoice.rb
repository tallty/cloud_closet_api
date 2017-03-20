# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  title      :string
#  amount     :float
#  type       :string
#  aasm_state :string
#  cel_name   :string
#  cel_phone  :string
#  postcode   :string
#  address    :string
#  date       :date
#  blance     :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_invoices_on_user_id  (user_id)
#

class Invoice < ApplicationRecord
end
