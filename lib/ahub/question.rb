module Ahub
  class Question
    extend Ahub::APIHelpers

    attr_accessor :id, :title, :body, :body_as_html, :author, :answerCount, :errors

    def self.create(title:, body:, topics:, username:, password:)
      url = "#{base_url}.json"
      payload = {title: title, body: body, topics: topics}
      user_headers = headers(username:username, password:password)

      response = RestClient.post(url, payload.to_json, user_headers)
      {error: nil, newQuestionURL: response.headers[:location]}
    rescue => e
      {error: e.message}
    end

    def initialize(attrs)
      @id = attrs[:id]
      @title = attrs[:title]
      @body = attrs[:body]
      @body_as_html = attrs[:bodyAsHTML]
      @topics = attrs[:topics]
      @answer_ids = attrs[:answers]
      @answerCount = attrs[:answerCount]
    end

    def url
      "#{self.class.base_url}/#{id}.json" if id
    end
  end
end
