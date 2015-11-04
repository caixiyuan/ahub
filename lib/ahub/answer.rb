module Ahub
  class Answer
    extend Ahub::APIHelpers

    def initialize(attrs)
    end

    def self.create(question_id:, body:, username:, password:)
      data = {body: body}

      url = "#{Ahub::DOMAIN}/services/v2/question/#{question_id}/answer.json"

      auth_headers = headers(username: username, password: password)

      OpenStruct.new(
        JSON.parse(
          RestClient.post(url, data.to_json, auth_headers),
          symbolize_names: true
        )
      )
    rescue => e
      {error: e.message}
    end

  end
end
