require "spec_helper"

module Ahub
  class APIClassTester
    include Ahub::ClassHelpers
    def create()
      url = "#{base_url}.json"

      response = RestClient.post(url, {}.to_json, admin_headers)
      find(object_id_from_response(response))
    end
  end
end

describe Ahub::ClassHelpers do
  let(:tester){ Ahub::APIClassTester.new({id: 100}) }
  describe 'attrs' do
    it 'has a read only id property' do
      expect(tester.id).to be(100)
    end
  end

  describe '#update' do
    it 'raises NotImplementedError' do
      expect{tester.update}.to raise_error(NotImplementedError)
    end
  end

  describe '#destroy' do
    it 'raises NotImplementedError' do
      expect{tester.update}.to raise_error(NotImplementedError)
    end
  end
end