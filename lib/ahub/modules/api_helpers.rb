module Ahub
  module APIHelpers
    require 'base64'

    def headers(username:'answerhub', password:'answerhub')
      encoded = "Basic #{::Base64.strict_encode64("#{username}:#{password}")}"

      {
        'Authorization' => encoded,
        'Accept' => "application/json",
        'Content-type' => "application/json",
      }
    end

    def admin_headers
      headers(username: Ahub::ADMIN_USER, password: Ahub::ADMIN_PASS)
    end

    def find(id=nil)
      url = base_url
      url +="/#{id}" if id
      url +='.json'

      new JSON.parse(RestClient.get(url, admin_headers), symbolize_names:true)
    rescue => e
      new({errors: e.message})
    end

    def base_url
      class_name = name.gsub(/Ahub::/, '').downcase
      "#{Ahub::DOMAIN}/services/v2/#{class_name}"
    end
  end
end
