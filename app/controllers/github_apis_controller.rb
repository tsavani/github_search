require './lib/api'

class GithubApisController < ApplicationController
  include Api

  def search
  end

  def index
  	#@file_name,@html_url,@repository,@key,@user,@user_link = [],[],[],[],[],[],[]
    @data = {
      file_name: [],
      html_url: [],
      repository: [],
      key: [],
      user: [],
      user_link: []
    }
  	# @path = []
  	@count = 0
    # get_data = github_search("https://api.github.com/search/code?q=ruby+user:twinks14")
    fetch_data(@data) 
  end

  def fetch_data data
    keywords = Keyword.all.pluck(:keyword)
    users = User.all.pluck(:user)
     users.each do |user| 
      keywords.each do |keyword|
        sleep(3)
        get_data = Api.github_search("https://api.github.com/search/code?q=#{keyword}+user:#{user}")
        if !get_data.blank? &&  get_data["items"].count != 0 
          @count += get_data["items"].count
          get_data["items"].each_with_index do |hash,index|
            data[:user] << user
            data[:key] << keyword
            data[:file_name] << get_data["items"][index]["name"]
            # @path << get_data["items"][index]["path"]
            data[:html_url] << get_data["items"][index]["html_url"]
            data[:repository] << get_data["items"][index]["repository"]["name"]
            data[:user_link] << get_data["items"][index]["repository"]["owner"]["html_url"]
          end
        end
      end
    end
  end
end
