
every :day, :at => '12:00am' do
	# do something in 1 day
	runner "User.create_bill" if Time.now.day == 1 
end
