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
  	# @path = []
  	@count = 0
    # get_data = github_search("https://api.github.com/search/code?q=ruby+user:twinks14")
    fetch_data(@data) 
    #html = ac.render_to_string(:template => './app/views/github_apis/index.html.erb',:locals => {:varable => @data})
    # html = ac.render_to_string(:template => './app/views/github_apis/index.html.erb', :formats => [:html], :layout => false, :locals => {:data => @data}, :handlers=>[:erb])
    # data = render_to_pdf(html)  #render_to_pdf called from lib/pdf.rb:6
    # send_data(data,
    #           :filename    => "gethub_search.pdf",
    #           :disposition => 'attachment')
    table_body = create_pdf(@data)
		Prawn::Document.generate("#{Rails.root}/public/github_search.pdf") do
      text 'Github Search', :align => :center, :style => :bold
      move_down 40
      #table(table_info, :cell_style => {:inline_format => true, :size => 8})
      #move_down 20
      table(table_body,
        :width => 440,
        :column_widths => [30, 80, 80, 100, 150],
        :cell_style => {:inline_format => true, :size => 8},
        :header => true
      )
      #move_down 20
      #table(total_sum, :cell_style => {:inline_format => true, :size => 8})
    end

    SendSearchMail.send_search_mail.deliver!

  end

  def create_pdf(data)
    table_body = [
      ['<b>#</b>', '<b>User #</b>', '<b>Match</b>', '<b>Repository</b>','<b>File Name</b>']
    ]
    #time_invoices = time_invoice_detail.time_invoices
    #total_amount = 0.0
    @count.times do |i|
      #amount = ti.total_hours * ti.hourly_rate
      table_body << ["#{i+1}", "#{data[:user][i]}",
        "#{data[:key][i]}", "#{data[:repository][i]}", "#{data[:file_name][i]}"]
    end
    table_body
  end


  def fetch_data data
    keywords = Keyword.all.pluck(:keyword)
    users = User.all.pluck(:user)
     users.each do |user| 
      keywords.each do |keyword|
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
