module Ahub
  class Group
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    attr_reader :name
    def initialize(attrs)
      @id = attrs[:id]
      @name = attrs[:name]
    end

    def assign_user(user_id)
      raise Exception("No Group Id") unless id

      move_url = "#{self.class.base_url}/#{id}/move.json?users=#{user_id}"
      RestClient.put("#{url}", self.class.admin_headers)
    rescue => e
      @error = e.message
    end
  end
end
