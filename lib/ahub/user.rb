module Ahub
  class User
    extend Ahub::APIHelpers

    def initialize(attrs)
    end

    def self.find(id=nil)
      url = "#{Ahub::DOMAIN}/services/v2/user"
      url += "/#{id}" if id
      url += '.json'
      OpenStruct.new(JSON.parse(RestClient.get(url, admin_headers), symbolize_names:true))
    rescue => e
      {error: e.message}
    end

    def self.create(username:, email:, password:nil)
      url = "#{Ahub::DOMAIN}/services/v2/user"
      data = {
        email: email,
        username: username,
        password: password || Ahub::DEFAULT_PASSWORD,
      }

      response = RestClient.post(url, data.to_json, admin_headers)
      {error: nil, newUserURL: response.headers[:location]}
    rescue => e
      {error: e.message}
    end
  end
end
