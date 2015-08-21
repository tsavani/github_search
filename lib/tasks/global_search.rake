require './lib/crawl_github'

namespace :global_search do
  desc "TODO"
  task github: :environment do

    #Getting all links from github global serach
    result = {}
    keywords = Keyword.pluck(:keyword)
    keywords.each do |key|
      search_github = SearchGithub.new
	    search_github.keyword = key
      result[key] = search_github.fetch_links(search_github.search)
      sleep(10)
    end
    
    #insert all links into database table use of truncate load...!!!
    if result.present?
      ActiveRecord::Base.transaction do
        count = 0
        trunc_table 'github_currents'
        Rails.logger.info("Table: github_currents truncated at #{Time.now}")
        result.each_pair do |key,value|
          result[key].each do |github_info|
            username = github_info[0]
            repo = github_info[1]
            file_location = github_info[2]
            GithubCurrent.create!({:user_name => username, :keyword => key, :repository => repo, :file_location => file_location})
            Rails.logger.info "#{key} match : #{count+=1} record inserted...!!!"
          end
        end
        Rails.logger.info("Table: github_currents has been updated successfully at #{Time.now}")
      end

      #refresh table with new values from table: github_currents..!!! 
      ActiveRecord::Base.transaction do
        trunc_table 'github_stables'
        Rails.logger.info("Table: github_stable truncated at #{Time.now}")
        ActiveRecord::Base.connection.execute("insert into github_stables select * from github_currents")
        Rails.logger.info("Table : github_stable has been updated successfully at #{Time.now}")
      end
    else
      ActiveRecord::Base.transaction do
        %w(github_currents github_stables).each {|table| trunc_table table}
      end
    end
  end
end

def trunc_table table_name
   ActiveRecord::Base.connection.execute("truncate #{table_name}")
end