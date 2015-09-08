module Ahub::APIHelpers
  require 'base64'
  def headers(username:'answerhub', password:'answerhub')
    encoded = "Basic #{::Base64.strict_encode64("#{username}:#{password}")}"

    headers  = {
      'Authorization' => encoded,
      'Accept' => "application/json",
      'Content-type' => "application/json",
    }
  end
end
