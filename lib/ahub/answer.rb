module Ahub
  class Answer
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    def self.create(question_id:, body:, username:, password:)
      url = "#{Ahub::DOMAIN}/services/v2/question/#{question_id}/answer.json"

      create_resource(url: url, payload: {body: body}, headers: headers(username: username, password: password))
    end

    def initialize(attrs)
      super(attrs)
      @author = Ahub::User.new(attrs[:author])
    end

    def user
      @author
    end
  end
end
