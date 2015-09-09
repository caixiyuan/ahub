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
  end
end
