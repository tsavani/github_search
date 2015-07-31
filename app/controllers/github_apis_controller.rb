class GithubApisController < ApplicationController
  def search

  	#https://api.github.com/search/code?q=@keyword+user:@user
  end

  def index
  	@file_name = []
  	@path = []
  	@html_url = [] 
  	@repository = []
  	get_data = github_search("https://api.github.com/search/code?q=parking+user:saurabh201189")
  	@count = get_data["items"].count
  	get_data["items"].each_with_index do |hash,index|
  		@file_name << get_data["items"][index]["name"]
  		@path << get_data["items"][index]["path"]
  		@html_url << get_data["items"][index]["html_url"]
  		@repository << get_data["items"][index]["repository"]["name"]
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
