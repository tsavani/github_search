require 'logger'

namespace :db do
  desc "Clean the sessions table once a day"
  task :clean_sessions => :environment do
    logger = Logger.new("#{Rails.root}/log/session-cleaner.log")
    logger.debug "------    Cleaning the sessions table @ #{Time.now}   ----------"
    ActiveRecord::SessionStore::Session.destroy_all( ['updated_at <?', 2.hours.ago] )
    logger.debug "------    Completed   ---------- \n\n"
  end
end