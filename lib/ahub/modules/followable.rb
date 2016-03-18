module Ahub
  module Followable
    def self.included(klass)
      klass.class_eval do
        include Ahub::APIResource
      end
    end
    
    def followers(page = 0, page_size = 50)
      return [] if id.nil?
      self.class.get_resource(url: "#{self.class.base_url}/#{id}/followers.json?page=#{page}&pageSize=#{page_size}", headers: admin_headers, klass: Ahub::User)
    end
  end
end