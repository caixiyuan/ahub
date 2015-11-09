module Ahub
  class Answer
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    attr_reader :body, :body_as_html, :author

    def initialize(attrs)
      @id = attrs[:id]
      @body = attrs[:body]
      @body_as_html = attrs[:bodyAsHTML]
      @author = Ahub::User.new(attrs[:author])
    end

    def user
      @author
    end

    def self.create(question_id:, body:, username:, password:)
      data = {body: body}

      url = "#{Ahub::DOMAIN}/services/v2/question/#{question_id}/answer.json"

      auth_headers = headers(username: username, password: password)

      new JSON.parse(RestClient.post(url, data.to_json, auth_headers), symbolize_names: true)
    end
  end
end
