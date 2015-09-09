require 'rest_client'
require 'pry-byebug'
require 'ahub/modules/api_helpers'

module Ahub
  class Question
    extend Ahub::APIHelpers

    def self.find(id=nil)
      url = "#{Ahub::DOMAIN}/services/v2/question"
      url +="/#{id}" if id
      url +='.json'

      OpenStruct.new(JSON.parse(RestClient.get(url, admin_headers), symbolize_names:true))
    rescue => e
      {error: e.message}
    end

  end
end
