class Date < Object
	def in_current_month? 
		_today = Time.zone.now
		(_today.strftime("%Y-%m-1").to_date .. _today.strftime("%Y-%m-#{Time.days_in_month(_today.month)}").to_date).cover?(self)
	end

	def in_last_month? 
		_day_in_last_month = Time.zone.now - 1.month
		(_day_in_last_month.strftime("%Y-%m-1").to_date .. _day_in_last_month.strftime("%Y-%m-#{Time.days_in_month(_day_in_last_month.month)}").to_date).cover?(self)
	end

	def in_the_month? year, month
		("#{year}-#{month}-1".to_date .. "#{year}-#{month}-#{Time.days_in_month(month)}".to_date).cover?(self)
	end

	def before_the_month? year, month
		self < "#{year}-#{month}-1".to_date
	end

	def behind_the_month? year, month
		self > "#{year}-#{month}-#{Time.days_in_month(month)}".to_date
	end
end