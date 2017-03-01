# == Schema Information
#
# Table name: valuation_chests
#
#  id              :integer          not null, primary key
#  price_system_id :integer
#  aasm_state      :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  start_time      :date
#
# Indexes
#
#  index_valuation_chests_on_price_system_id  (price_system_id)
#  index_valuation_chests_on_user_id          (user_id)
#

class ValuationChest < ApplicationRecord
  belongs_to :price_system
  belongs_to :user
  has_many :exhibition_chests
  
  delegate :title, :price, to: :exhibition_unit#, allow_nil: true
end
