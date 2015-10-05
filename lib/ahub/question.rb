require 'rest_client'
require 'ahub/modules/api_helpers'

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

    def self.create_csv(title:, body:, topics:, user_id:, count:20, path:)
      ::CSV.open(path, 'w', ) do |csv|
        (0..count).each do |n|
          csv << [
            "question",
            "##{n}: #{title}",
            "##{n}: #{body}",
            0,
            topics,
            1443470000000,
            '',
            '',
            user_id
          ]
        end
      end
    end

    private

    def self.base_url
      "#{Ahub::DOMAIN}/services/v2/question"
    end
  end
end
