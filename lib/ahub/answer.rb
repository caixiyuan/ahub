module Ahub
  class Answer
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    def self.create(question_id:, body:, username:, password:)
      url = "#{Ahub::DOMAIN}/services/v2/question/#{question_id}/answer.json"

      make_post_call(url, {body: body}, headers(username: username, password: password))
    end

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
  end
end
