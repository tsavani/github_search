require './lib/api'
require 'prawn/table'

namespace :github_search do
  desc "TODO"
  task pdf: :environment do
  	@data = {
      file_name: [],
      html_url: [],
      repository: [],
      key: [],
      user: [],
      user_link: []
    }
  	@count = 0
    fetch_data(@data)   # method call for fetching data from API line # 43
    table_body = create_pdf(@data)
		Prawn::Document.generate("#{Rails.root}/public/github_search.pdf") do   #Crate PDF with use of Prawn gem. to use
      text 'Github Search', :align => :center, :style => :bold              # table attribute 
      move_down 40
      table(table_body,
        :width => 440,
        :column_widths => [30, 80, 80, 100, 150],
        :cell_style => {:inline_format => true, :size => 8},
        :header => true
      )
    end
    SendSearchMail.send_search_mail.deliver!
  end

  def create_pdf(data)
    #create table heading and store into Array
    if @count > 0
    table_body = [
      ['<b>#</b>', '<b>User #</b>', '<b>Match</b>', '<b>Repository</b>','<b>File Name</b>'] 
    ] 
    #create table data and store into Array
    @count.times do |i|
      table_body << ["#{i+1}", "#{data[:user][i]}",
        "#{data[:key][i]}", "#{data[:repository][i]}", "<color rgb='0000FF'><a style='color:blue;' href='#{data[:html_url][i]}'>#{data[:file_name][i]}</a></color>" ]     
    end
  else
    table_body = ["<h3>No match found..!!!</h3>"]
  end
    table_body  # return Array with data to populate PDF.
  end

  # Method to get all keywords and users, api call to get all results and store into Array.
  def fetch_data data
    keywords = Keyword.all.pluck(:keyword)    #to get only keyword column from keywords table
    users = User.all.pluck(:user)  #to get only user column from users table
     users.each do |user| 
      keywords.each do |keyword|
        get_data = Api.github_search("https://api.github.com/search/code?q=#{keyword}+user:#{user}")
        sleep(3)
        if !get_data.blank? &&  get_data["items"].count != 0 
          @count += get_data["items"].count
          get_data["items"].each_with_index do |hash,index|    #Merge each search data into Hash of Array @data[[][]]
            data[:user] << user
            data[:key] << keyword
            data[:file_name] << get_data["items"][index]["name"]
            data[:html_url] << get_data["items"][index]["html_url"]
            data[:repository] << get_data["items"][index]["repository"]["name"]
            data[:user_link] << get_data["items"][index]["repository"]["owner"]["html_url"]
          end
        end
      end
    end
  end
end
