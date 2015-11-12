module Ahub
  class User
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    def self.create(username:, email:, password:nil)
      url = "#{base_url}.json"

      payload = {
        email: email,
        username: username,
        password: password || Ahub::DEFAULT_PASSWORD,
      }

      create_resource(url: url, payload: payload, headers: admin_headers)
    end

    def self.find_by_username(username)
      matches = find_all(params: {q: username})
      matches.find{|user| user.username.downcase.strip == username.downcase.strip}
    end

    def initialize(attrs)
      super
      @groups = attrs[:groups].map{|group| Ahub::Group.new(group)} if attrs[:groups]
    end

    def is_complete?
      !!@complete
    end

    def questions
      unless @questions
        response = self.class.get_resource(url: "#{self.class.base_url}/#{id}/question.json", headers: self.class.admin_headers)
        @questions = response[:list].map{ |question| Ahub::Question.new(question) }
      end

      @questions
    end

    def answers
      unless @answers
        response = self.class.get_resource(url: "#{self.class.base_url}/#{id}/answer.json", headers: self.class.admin_headers)
        @answers = response[:list].map{ |answer| Ahub::Answer.new(answer) }
      end

      @answers
    end
  end
end
