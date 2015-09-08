require 'rest_client'
require 'pry-byebug'
require 'ahub/modules/api_helpers'

module Ahub
  class Answer
    extend Ahub::APIHelpers
    def self.find(id)
    end

    def self.create(question_id:, body:)
      data = {
        body: body
      }

      url = "http://localhost:8888/services/v2/question/#{question_id}/answer.json"

      JSON.parse RestClient.post(url, data.to_json, headers)
    rescue => e
      {error: e.message}
    end

    def self.get_all_by_question(question_id:)

    end
  end
end
