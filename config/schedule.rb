# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

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

set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every '00 1 15,30 4,6,9,11 *' do
	rake "github_search:pdf", :environment => 'devutility'
end


every '00 1 15,31 1,3,5,7,8,10,12 *' do 
	rake "github_search:pdf", :environment => 'devutility'
end


every '00 1 15,28 2 *' do
	rake "github_search:pdf", :environment => 'devutility'
end

