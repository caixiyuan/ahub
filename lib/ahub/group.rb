module Ahub
  class Group
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    attr_reader :name
    def initialize(attrs)
      @id = attrs[:id]
      @name = attrs[:name]
    end

    def add(user_id)
      add_user(user_id)
    end

    def add_user(user_id)
      raise Exception("No Group Id") unless id

      move_url = "#{self.class.base_url}/#{id}/add.json?users=#{user_id}"
      RestClient.put("#{url}", self.class.admin_headers)
      true
    rescue => e
      false
    end
  end
end
