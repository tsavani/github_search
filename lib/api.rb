module Api
	def self.github_search(url)
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