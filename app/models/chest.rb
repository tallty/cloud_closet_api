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
#  end_day         :date
#  start_day       :date
#
# Indexes
#
#  index_chests_on_price_system_id  (price_system_id)
#  index_chests_on_user_id          (user_id)
#

class Chest < ApplicationRecord
  include AASM

  aasm do 
  	state :waiting, initial: true
  	state :using, :will_expire, :expire

  	event :release do 
  		transitions from: :waiting, to: :using
		end

		event :turn_to_will_expire do 
			transitions from: :using, to: :will_expire, :after => :send_notice
		end

	end
  belongs_to :user
  belongs_to :price_system

  before_save :fit_price_system

  # schu ... 
  # every day 检查 will_expire
  def self.check_end_time
  	
  end
  
  def send_notice
  	
  end

  private
  	def fit_price_system
  		_price_system = self.price_system
  		self.max_count = _price_system.max_count
  		self.chest_type = _price_system.title
  	end
end
