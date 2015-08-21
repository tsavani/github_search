class SendSearchMail < ApplicationMailer
	def send_search_mail
	  attachments["github_search.pdf"] = File.read("#{Rails.root}/public/github_search.pdf")
	  recipient = ['Twinkal_k.Savani@gmail.com']
	  recipient = ['Twinkal_k.Savani@gmail.com'] if Rails.env.eql? 'production'
	  cc = ['Twinkal_k.Savani@gmail.com']
	  #cc = ["#{Person.find_by_id(@contractor_id).email_id}", 'Ben_Mitchell@mckinsy.com'] if Rails.env.eql? 'production'
	  subject = "Github Search Results"
	  subject = "<#{Rails.env}> #{subject}" unless Rails.env.eql? 'production'
	  mail(:to => recipient, :subject => subject, :cc => cc)
	end
end