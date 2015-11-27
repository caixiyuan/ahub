require 'base64'
require 'active_support/concern'

module Ahub
  module Deletable
    extend ActiveSupport::Concern

    included do
      alias_method :restore, :undelete
    end

    def delete(headers:)
      self.class.update_node(action: :delete, node_id: id, headers: headers)
    end

    def undelete(headers:)
      self.class.update_node(action: :undelete, node_id: id, headers: headers)
    end

    class_methods do
      def update_node(action:, node_id:, headers:)
        raise Exception.new('Unknown Action: use :delete or :undelete') unless %i(delete undelete).include?(action)
        url = "#{Ahub::DOMAIN}/services/v2/node/#{node_id}/#{action}.json"

        begin
          response = RestClient.put(url, {}.to_json, headers)
          response.code == 200
        rescue Exception => e
          false
        end
      end
    end
  end
end
