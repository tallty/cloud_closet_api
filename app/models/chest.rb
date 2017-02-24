# == Schema Information
#
# Table name: chests
#
#  id              :integer          not null, primary key
#  title           :string
#  chest_type      :string
#  max_count       :integer
#  user_id         :integer
#  price_system_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_chests_on_price_system_id  (price_system_id)
#  index_chests_on_user_id          (user_id)
#

class Chest < ApplicationRecord
  belongs_to :user
  belongs_to :price_system

  before_save :fit_price_system

  private
  	def fit_price_system
  		_price_system = self.price_system
  		self.max_count = _price_system.max_count
  		self.chest_type = _price_system.title
  	end
end
