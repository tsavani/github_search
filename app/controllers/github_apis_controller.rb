class GithubApisController < ApplicationController

  def search

  	#https://api.github.com/search/code?q=@keyword+user:@user
  end

  def index
  	# @file_name = []
  	# @path = []
  	@html_url = [] 
  	@repository = []
  	@key = []
    @user = []
    @user_link = []
  	@keywords = Keyword.all.pluck(:keyword)
    @users = User.all.pluck(:user)
  	@count = 0

    # get_data = github_search("https://api.github.com/search/code?q=ruby+user:twinks14")
    # @hi = get_data["items"].count

    @users.each do |user| 
  	  @keywords.each do |keyword|
	  	  get_data = github_search("https://api.github.com/search/code?q=#{keyword}+user:#{user}")
	  	  if !get_data.blank? &&  get_data["items"].count != 0  
          @count += get_data["items"].count
	  		  get_data["items"].each_with_index do |hash,index|
            @user << user
	  			  @key << keyword
	  			  # @file_name << get_data["items"][index]["name"]
	  			  # @path << get_data["items"][index]["path"]
	  			  @html_url << get_data["items"][index]["html_url"]
	  			  @repository << get_data["items"][index]["repository"]["name"]
            @user_link << get_data["items"][index]["repository"]["owner"]["html_url"]
			    end
		    end
      end
	  end
  end

  def github_search(url)
  	uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    response = begin
      http.request(request)
    rescue Exception => e
      e.message
    end
    JSON.parse(response.body) if response.is_a?(Net::HTTPOK)
  end
end
