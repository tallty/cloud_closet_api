# == Schema Information
#
# Table name: chests
#
#  id                     :integer          not null, primary key
#  title                  :string
#  chest_type             :string
#  max_count              :integer
#  user_id                :integer
#  price_system_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  end_day                :date
#  start_day              :date
#  last_time_inc_by_month :integer
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
  		transitions from: :waiting, to: :using, :after => :set_rent_time_range
		end

		event :turn_to_will_expire do 
			transitions from: :using, to: :will_expire, :after => :send_will_expire_notice
		end

	end
  belongs_to :user
  belongs_to :price_system
  has_many :chest_items

  before_save :fit_price_system
  before_destroy :hs_items?

  delegate :price, to: :price_system
  # schu ... 
  # every day 检查 will_expire
  def self.check_end_time
  	Chest.using.each {|chest| chest.turn_to_will_expire! if Time.zone.now > chest.end_time - 7.day }
  end
  
  # 即将到期发送提示
  def send_will_expire_notice
  	
  end

  # 某月账单  默认上一月
  def get_monthly_rent_charge year_num=(Time.zone.now - 1.month).year, month_num=(Time.zone.now - 1.month).month
  	return 0 if self.end_day < self.start_day || self.end_day.before_the_month(year_num, month_num) || self.start_day.behind_the_month(year_num, month_num)
  	_start = self.start_day.in_last_month? ? self.start_day.day : 1
  	_end = self.end_day.in_last_month? ? self.end_day.day : Time.days_in_month((Time.zone.now - 1.month).month)
  	(( _end - _start + 1 ) * self.price).round(2)
  end


  def set_rent_time_range
  	self.start_day = Time.zone.today
  	self.end_day = self.start_day + self.last_time_inc_by_month.month	
  	self.save
  end

  private
  	def fit_price_system
  		_price_system = self.price_system
  		self.max_count = _price_system.max_count
  		self.chest_type = _price_system.title
  	end

  	def has_items?
  		raise "衣柜中仍有衣服" if self.chest_items.any?
  	end
end
