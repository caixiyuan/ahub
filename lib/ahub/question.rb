module Ahub
  class Question
    extend Ahub::APIHelpers

    def self.find(id=nil)
      url = base_url
      url +="/#{id}" if id
      url +='.json'

      OpenStruct.new(JSON.parse(RestClient.get(url, admin_headers), symbolize_names:true))
    rescue => e
      {error: e.message}
    end

    def self.create(title:, body:, topics:, username:, password:)
      url = "#{base_url}.json"
      payload = {title: title, body: body, topics: topics}
      user_headers = headers(username:username, password:password)

      response = RestClient.post(url, payload.to_json, user_headers)
      {error: nil, newQuestionURL: response.headers[:location]}
    rescue => e
      {error: e.message}
    end
  end
end
