module TestHelpers
  def active_link?(url)
    uri = URI.parse(url)
    response = nil
    Net::HTTP.start(uri.host, uri.port) { |http|
      response = http.head(uri.path.size > 0 ? uri.path : "/")
    }
    response.code == "200"
  end
end
