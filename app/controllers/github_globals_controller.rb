class GithubGlobalsController < ApplicationController
  def index
  	 @data = {
      file_name: [],
      file_location: [],
      repository: [],
      repository_link: [],
      key: [],
      user: [],
      user_link: []
    }
    link = 'http://github.com'
  	@global_search = GithubStable.all
  	@global_search.each do |r|
  		@data[:user] << r.user_name.tr('/', '')
  		@data[:user_link] << link + r.user_name
  		@data[:repository] << r.repository.split('/')[-1]
  		@data[:repository_link] << link + r.repository
  		@data[:file_name] <<  r.file_location.split('/')[-1]
  		@data[:file_location] << link + r.file_location
  		@data[:key] << r.keyword
  	end
  	@count = @data[:user].count
  end
end
