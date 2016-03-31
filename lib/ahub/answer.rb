module Ahub
  class Answer
    include Ahub::Followable
    include Ahub::Deletable

    def self.create(question_id:, body:, username:, password:)
      url = "#{Ahub::DOMAIN}/services/v2/question/#{question_id}/answer.json"

      create_resource(url: url, payload: {body: body}, headers: headers(username: username, password: password))
    end

    def initialize(attrs)
      super
      @author = Ahub::User.new(attrs[:author])
    end

    def user
      @author
    end

    def html_url
      "#{Ahub::DOMAIN}/answers/#{id}/view.html" if id
    end
  end
end
