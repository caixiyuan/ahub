module Ahub
  class Answer
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    attr_accessor :body, :author

    def initialize(attrs)
      @id = attrs[:id]
      @error = attrs[:error]

      @body = attrs[:body]
      @body = attrs[:bodyAsHTML]
      # @author = Ahub::User.new(attrs[:author]) # this is an incomplete user object.
    end

    def user
      @author
    end

    def self.create(question_id:, body:, username:, password:)
      data = {body: body}

      url = "#{Ahub::DOMAIN}/services/v2/question/#{question_id}/answer.json"

      auth_headers = headers(username: username, password: password)

      new JSON.parse(RestClient.post(url, data.to_json, auth_headers), symbolize_names: true)
    rescue => e
      new({error: e.message})
    end

  end
end
