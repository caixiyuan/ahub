module Ahub
  class Question
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    attr_accessor :title, :body, :body_as_html, :author, :answerCount
    attr_reader :space_id

    def self.create(title:, body:, topics:, space_id: nil, username:, password:)
      url = "#{base_url}.json"
      payload = {title: title, body: body, topics: topics}
      payload[:spaceId] = space_id if space_id

      user_headers = headers(username:username, password:password)

      response = RestClient.post(url, payload.to_json, user_headers)

      question_id = response.headers[:location].match(/(?<id>\d*)\.json/)[:id]
      find(question_id)
    rescue => e
      new({error: e.message})
    end

    def initialize(attrs)
      @id = attrs[:id]
      @error = attrs[:error]

      @answer_ids = attrs[:answers]
      @answerCount = attrs[:answerCount]
      @body = attrs[:body]
      @body_as_html = attrs[:bodyAsHTML]
      @space_id = attrs[:primaryContainerId]
      @title = attrs[:title]
      @topics = attrs[:topics]
    end

    def move(space_id:)
      raise Exception("No Question Id") unless id

      move_url = "#{self.class.base_url}/#{id}/move.json?space=#{space_id}"
      RestClient.put("#{url}", self.class.admin_headers)
    rescue => e
      @error = e.message
    end

    def url
      "#{self.class.base_url}/#{id}.json" if id
    end

    def to_s
      url
    end
  end
end
