require 'spec_helper'

module Ahub
  class APIDeletableTester
    include Ahub::Deletable

    def id
      123
    end
  end
end

describe Ahub::Deletable do
  let(:tester){ Ahub::APIDeletableTester.new }

  describe '#delete' do
    it 'returns the result of ::update node' do
      expect(Ahub::APIDeletableTester).to receive(:update_node).
        with({action: :delete, node_id: 123, headers: 'head-stuff'}).
        and_return(:response)

      expect(tester.delete(headers: 'head-stuff')).to be(:response)
    end
  end

  describe '#undelete' do
    it 'returns the result of ::update node' do
      expect(Ahub::APIDeletableTester).to receive(:update_node).
        with({action: :undelete, node_id: 123, headers: 'head-stuff'}).
        and_return(:response)

      expect(tester.undelete(headers: 'head-stuff')).to be(:response)
    end
  end

  describe '::update_node' do
    it 'raises an exeption if an unknown action is sent' do
      expect{
        Ahub::APIDeletableTester.update_node(action: :what, node_id: 888, headers: {a:1})
      }.to raise_error('Unknown Action: use :delete or :undelete')
    end
    context 'when a valid action is passed' do
      it 'returns false if the call raises an exeption' do
        expect(RestClient).to receive(:put).and_raise('boom')
        expect(tester.delete(headers: {a:1})).to be(false)
      end

      it 'make expected API call for delete' do
        expect(RestClient).to receive(:put).
          with("#{Ahub::DOMAIN}/services/v2/node/888/delete.json", {}.to_json, {a:1})

        Ahub::APIDeletableTester.update_node(action: :delete, node_id: 888, headers: {a:1})
      end

      it 'returns true if response code is 200' do
        allow(RestClient).to receive(:put).and_return(double('Response', {code: 200}))

        expect(Ahub::APIDeletableTester.update_node(action: :delete, node_id: 888, headers: {a:1})).to be(true)
      end

      it 'returns false if response code is not 200' do
        allow(RestClient).to receive(:put).and_return(double('Response', {code: 201}))
        expect(Ahub::APIDeletableTester.update_node(action: :delete, node_id: 888, headers: {a:1})).to be(false)
      end
    end
  end
end
