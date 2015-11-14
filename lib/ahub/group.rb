module Ahub
  class Group
    include Ahub::APIResource

    def add(user_id)
      add_user(user_id)
    end

    def self.find_by_name(group_name)
      matches = find_all
      matches.find{|group| group.name.downcase.strip == group_name.downcase.strip}
    end

    def add_user(user_id)
      raise Exception("No Group Id") unless id

      move_url = "#{self.class.base_url}/#{id}/add.json?users=#{user_id}"
      RestClient.put("#{move_url}", self.class.admin_headers)
      true
    rescue => e
      false
    end
  end
end
