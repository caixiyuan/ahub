require 'spec_helper'

module Ahub
  class Tester
    extend Ahub::APIHelpers
    def initialize(params)
    end
  end
end

describe Ahub::APIHelpers do
  describe '::find' do
    it 'returns an empty array if nothing comes back from the sever' do
      expect(RestClient).to receive(:get).with(
        "#{Ahub::Tester.base_url}/1.json",
        Ahub::Tester.admin_headers
      ).and_raise(Exception.new('barf'))

      tester = nil

      expect{tester = Ahub::Tester.find(1)}.to raise_error
      expect(tester.error).to eq('barf')
    end

    context 'when server has a useful response' do
      let(:server_response) do
        {page: 1, pageSize: 15, pageCount: 5, list: [single_response]}.to_json
      end

      let(:single_response){ {id: 8, title: 'foo'} }

      before do
        expect(RestClient).to receive(:get).with(
          "#{Ahub::Tester.base_url}/8.json",
          Ahub::Tester.admin_headers
        ).and_return(single_response.to_json)
      end

      it 'makes a call to index route for all questions and returns an array of objects.' do
        expect(Ahub::Tester.find(8)).to be_a(Ahub::Tester)
      end
    end

    context 'when args are present' do
      xit 'makes a call to index route with arguments'
    end
  end

  describe '::base_url' do
    #for simplicity, I'm simply sending this private method call.
    it 'returns a class derrived from the class' do
      expect(Ahub::Tester.send(:base_url)).to eq("#{Ahub::DOMAIN}/services/v2/tester")
    end
  end
end
