module Ahub
  module Followable
    def self.included(klass)
      klass.class_eval do
        include Ahub::APIResource
      end
    end
    
    def followers(page = 0, page_size = 20)
      return [] if id.nil?
      class_name = self.class.name.gsub(/Ahub::/, '').downcase
      class_name = 'node' if ['question', 'answer', 'comment'].include?(class_name)
      self.class.get_resources(url: "#{Ahub::DOMAIN}/services/v2/#{class_name}/#{id}/followers.json?page=#{page}&pageSize=#{page_size}", headers: admin_headers, klass: Ahub::User)
    end
  end
end