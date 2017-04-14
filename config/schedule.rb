# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "./log/cron_log.log"

every '0 1 1 * *' do
  runner "RentService.deducte_all_user_rent"
end

# Learn more: http://github.com/javan/whenever
