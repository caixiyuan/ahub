module Ahub
  class User
    include Ahub::APIResource

    def self.create(username:, email:, password:)
      url = "#{base_url}.json"

      payload = {email: email, username: username, password: password}

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

    def questions
      unless @questions
        url = "#{self.class.base_url}/#{id}/question.json"
        @questions = self.class.get_resources(url: url, headers: self.class.admin_headers, klass: Ahub::Question)
      end

      @questions
    end

    def answers
      unless @answers
        url = "#{self.class.base_url}/#{id}/answer.json"
        @answers = self.class.get_resources(url: url, headers: self.class.admin_headers, klass: Ahub::Answer)
      end

      @answers
    end

    def actions
    end

    def follows
    end

    def followers
    end
  end
end
