# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :output, "#{path}/log/cron.log"

every :day, at: '6am' do
  # specify the task name as a string
  rake 'style:new_issue'
end

# every 2.minutes do
#   puts 'runing cron job'
#   # specify the task name as a string
#   rake 'style:say_hello'
# end

# to set it for development envriroment
# whenever --update-crontab --set environment='development'

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
