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

      response = RestClient.post(url, payload.to_json, admin_headers)
      find(object_id_from_response(response))
    end

    def self.find_by_username(username)
      matches = find_all(params: {q: username})
      matches.find{|user| user.username.downcase.strip == username.downcase.strip}
    end

    attr_reader :username, :realname, :avatar_url,
      :post_count, :follow_count, :follower_count,
      :active, :suspended, :deactivated

    def initialize(attrs)
      @username = attrs[:username]
      @realname = attrs[:realname]
      @avatar_url = attrs[:avatar]
      @post_count = attrs[:postCount]
      @follow_count = attrs[:followCount]
      @follower_count = attrs[:followerCount]
      @active = attrs[:active]
      @suspended = attrs[:suspended]
      @deactivated  =attrs[:deactivated]
      @complete = attrs[:complete]
    end

    def is_complete?
      !!@complete
    end
  end
end
