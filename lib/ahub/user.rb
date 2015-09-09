require 'rest_client'
require 'pry-byebug'
require 'csv'
require 'humanize'
require 'ahub/modules/api_helpers'

module Ahub
  class User
    extend Ahub::APIHelpers
    def self.find(id=nil)
      url = "#{Ahub::DOMAIN}/services/v2/user"
      url += "/#{id}" if id
      url += '.json'
      OpenStruct.new(JSON.parse(RestClient.get(url, admin_headers), symbolize_names:true))
    rescue => e
      {error: e.message}
    end

    def self.create(username:, email:, password:)
      url = "#{Ahub::DOMAIN}/services/v2/user"
      data = {
        email: email,
        username: username,
        password: password,
      }

      response = RestClient.post(url, data.to_json, admin_headers)
      {error: nil, newUserURL: response.headers[:location]}
    rescue => e
      {error: e.message}
    end

    def self.create_test_user(prefix: 'ahuser', index: 0)
      number = '%03d' % index
      username = "#{prefix}#{number}"
      create(
        email: "#{username}@example.com",
        username: username,
        password: Ahub::DEFAULT_PASSWORD,
      )
    end

    def self.create_user_csv(prefix: 'ahuser', count: 10)
      ::CSV.open('./users.csv', 'w') do |csv|
        (0..count).each do |n|
          number = '%03d' % n
          username = "#{prefix}#{number}"
          csv << [
            "#{username}",
            "#{prefix} user-#{n.humanize.gsub(/\s/,'-')}",
            "#{username}@example.com",
            "password"
          ]
        end
      end
    end
  end
end
