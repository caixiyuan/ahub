module Ahub
  class Question
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    def self.create(title:, body:, topics:, space_id: nil, username:, password:)
      url = "#{base_url}.json"

      payload = {title: title, body: body, topics: topics}
      payload[:spaceId] = space_id if space_id

      user_headers = headers(username:username, password:password)

      create_resource(url: url, payload: payload, headers: user_headers)
    end

    attr_accessor :title, :body, :body_as_html

    def user
      @author
    end

    def move(space_id:)
      raise Exception("No Question Id") unless id

      move_url = "#{self.class.base_url}/#{id}/move.json?space=#{space_id}"
      RestClient.put("#{url}", self.class.admin_headers)
    end

    def url
      "#{self.class.base_url}/#{id}.json" if id
    end

    def to_s
      url
    end
  end
end
