module Ahub
  class Question
    include Ahub::APIResource

    def self.create(title:, body:, topics:, space_id: nil, username:, password:)
      url = "#{base_url}.json"

      payload = {title: title, body: body, topics: topics}
      payload[:spaceId] = space_id if space_id

      user_headers = headers(username:username, password:password)

      create_resource(url: url, payload: payload, headers: user_headers)
    end

    def self.is_question(query:)
      get_resource(url: "#{base_url}/isQuestion.json?q=#{URI.encode(query)}", headers: admin_headers)[:result]
    end

    def self.find_all_by_text(query:)
      get_resources(url: "#{base_url}.json?q=#{URI.encode(query.downcase.strip)}", headers: admin_headers, klass: Ahub::Question)
    end

    def self.find_by_title(title)
      find_all_by_text(query: title).find{|question| question.title.strip.downcase == title.downcase.strip}
    end

    attr_accessor :title, :body, :body_as_html

    def initialize(attrs)
      super
      @author = Ahub::User.new(attrs[:author]) if attrs[:author]
    end

    def find_answers_by_username(username)
      fetched_answers.select{|answer| answer.author.username == username}
    end

    def fetched_answers
      @fetched_answers || @answers.map{|answer_id| Ahub::Answer.find(answer_id)}
    end

    def user
      @author
    end

    def html_url
      "#{Ahub::DOMAIN}/questions/#{id}/#{slug}.html" if id
    end

    def json_url
      "#{self.class.base_url}/#{id}.json" if id
    end

    def to_s
      html_url
    end
  end
end
