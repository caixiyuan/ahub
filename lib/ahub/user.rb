require 'rest_client'
require 'pry-byebug'
require 'csv'
require 'humanize'
require 'ahub/modules/api_helpers'

module Ahub
  class User
    extend Ahub::APIHelpers
    def self.find(id)
      url = "http://localhost:8888/services/v2/user/#{id}.json"
      JSON.parse(RestClient.get url, headers)
    rescue => e
      {error: e.message}
    end

    def self.create_test_user(prefix: 'ahuser', index: 0)
      url = "http://localhost:8888/services/v2/user"
      number = '%03d' % index
      username = "#{prefix}#{number}"
      data = {
        email: "#{username}@example.com",
        username: username,
        password: 'password',
      }

      JSON.parse RestClient.post(url, data.to_json, headers)
      {error: nil, newUserURL: response.headers[:location]}
    rescue => e
      {error: e.message}
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
