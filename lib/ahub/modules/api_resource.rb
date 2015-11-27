require 'base64'
require 'active_support/inflector'
require 'active_support/concern'

module Ahub
  module APIResource
    extend ActiveSupport::Concern

    attr_reader :attributes

    def update
      raise NotImplementedError
    end

    def initialize(attrs)
      @attributes = attrs
      attrs.each_pair do |k,v|
        attribute_name = k.to_s.underscore

        if instance_variable_get("@#{attribute_name}").nil?
          instance_variable_set("@#{attribute_name}", v)
        end

        next if respond_to?(k) && k != :id

        self.class.send(:define_method, attribute_name) do
          instance_variable_get("@#{__method__}")
        end
      end
    end

    class_methods do
      def headers(username:, password:)
        encoded = "Basic #{::Base64.strict_encode64("#{username}:#{password}")}"

        {
          'Authorization' => encoded,
          'Accept' => "application/json",
          'Content-type' => "application/json",
        }
      end

      def admin_headers
        headers(username: Ahub::ADMIN_USER, password: Ahub::ADMIN_PASS)
      end

      def find(id)
        url = "#{base_url}/#{id}.json"

        new get_resource(url: url, headers:admin_headers)
      rescue RestClient::ResourceNotFound => e
        nil
      end

      def find_all(params: nil, page: 1, pageSize: 30)
        url = "#{base_url}.json?page=#{page}&pageSize=#{pageSize}"

        if params
          params.each{|k,v| url << "&#{k}=#{URI.encode(v)}"}
        end

        get_resources(url: url, headers: admin_headers, klass: self)
      end

      def base_url
        class_name = name.gsub(/Ahub::/, '').downcase
        "#{Ahub::DOMAIN}/services/v2/#{class_name}"
      end

      def object_id_from_response(response)
        response.headers[:location].match(/(?<id>\d*)\.json/)[:id].to_i
      end

      def get_resource(url:, headers:)
        JSON.parse(RestClient.get(url, headers), symbolize_names:true)
      end

      def get_resources(url:, headers:, klass:)
        response = JSON.parse(RestClient.get(url, headers), symbolize_names:true)
        response[:list].map do |node|
          klass.new(node)
        end
      end

      private

      def create_resource(url:, payload:, headers:)
        response = RestClient.post(url, payload.to_json, headers)
        find(object_id_from_response(response))
      end
    end
  end
end
