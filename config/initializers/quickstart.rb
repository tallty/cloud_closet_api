# require 'rufus-scheduler'

# scheduler = Rufus::Scheduler.new

# scheduler.every '1d', :first_at => Time.zone.now.midnight + 12 * 3600 do
#   # do something in 1 day
#   User.create_bill if Time.zone.today.day == 1
# end

# scheduler.join