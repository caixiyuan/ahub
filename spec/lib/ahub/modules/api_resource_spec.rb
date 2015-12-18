require 'spec_helper'

module Ahub
  class APIResourceTester
    include Ahub::APIResource
    attr_writer :bbb

    def self.create()
      url = "#{base_url}.json"

      create_resource(url: url, payload: {}.to_json, headers: admin_headers)
    end

    def initialize(attrs)
      @predefined = 'original ivar'
      super
    end

    def predefined
      'original method'
    end
  end
end

describe Ahub::APIResource do
  let(:server_response) do
    {page: 1, pageSize: 15, pageCount: 5, list: [single_response]}
  end

  let(:single_response){ {id: 8, title: 'foo'} }

  describe 'class methdods' do
    describe '::find' do
      it 'swallows RestClient::ResourceNotFound & returns nil if nothing comes back from the sever' do
        allow(RestClient).to receive(:get).with(
          "#{Ahub::APIResourceTester.base_url}/1.json",
          Ahub::APIResourceTester.admin_headers
        ).and_raise(RestClient::ResourceNotFound)

        tester = Ahub::APIResourceTester.find(1)
        expect(tester).to be_nil
      end

      it 'allows other exceptions to be raised' do
        allow(RestClient).to receive(:get).with(
          "#{Ahub::APIResourceTester.base_url}/k.json",
          Ahub::APIResourceTester.admin_headers
        ).and_raise(RestClient::InternalServerError)

        expect{ Ahub::APIResourceTester.find('k') }.to raise_error(RestClient::InternalServerError)
      end

      context 'when server has a useful response' do
        it 'makes a call to index route for all questions and returns an array of objects.' do
          allow(RestClient).to receive(:get).with(
            "#{Ahub::APIResourceTester.base_url}/8.json",
            Ahub::APIResourceTester.admin_headers
          ).and_return(single_response.to_json)

          expect(Ahub::APIResourceTester.find(8)).to be_a(Ahub::APIResourceTester)
        end
      end
    end

    describe '::find_all' do
      context 'when args are present' do
        it 'makes a call to index route with arguments' do
          allow(RestClient).to receive(:get).with(
            "#{Ahub::APIResourceTester.base_url}.json?page=1&pageSize=50&foo=bar%20quat",
            Ahub::APIResourceTester.admin_headers
          ).and_return(server_response.to_json)

          expect(Ahub::APIResourceTester.find_all(params: {foo:'bar quat'})).to all(be_a(Ahub::APIResourceTester))
        end
      end
    end

    describe '::base_url' do
      it 'returns a class derrived from the class' do
        expect(Ahub::APIResourceTester.base_url).to eq("#{Ahub::DOMAIN}/services/v2/apiresourcetester")
      end
    end

    describe '::object_id_from_response' do
      it 'returns an integer for the id of the new record' do
        base_url = Ahub::APIResourceTester.base_url
        response = double(headers: {location: "#{base_url}/123.json"})
        expect(Ahub::APIResourceTester.object_id_from_response(response)).to eq(123)
      end
    end

    describe '::create' do
      let(:create_url){ "#{Ahub::APIResourceTester.base_url}.json" }
      let(:server_response){ double(headers: {location: "#{Ahub::APIResourceTester.base_url}/456.json"}) }

      it 'returns an Ahub::APIResourceTester instance if creation was successful' do
        expect(RestClient).to receive(:post).with(
          create_url, anything, Ahub::APIResourceTester.admin_headers
        ).and_return(server_response)

        expect(Ahub::APIResourceTester).to receive(:find).and_return(Ahub::APIResourceTester.new({}))

        answer = Ahub::APIResourceTester.create()
        expect(answer).to be_a(Ahub::APIResourceTester)
      end

      it 'returns an error if a failure occurs' do
        allow(RestClient).to receive(:post).with(
          create_url, anything, Ahub::APIResourceTester.admin_headers
        ).and_raise(RestClient::InternalServerError)

        expect{Ahub::APIResourceTester.create()}.to raise_error(RestClient::InternalServerError)
      end
    end

    describe '::get_resources' do
      it 'returns an array of instances of a class' do
        expect(RestClient).to receive(:get).
          with(
            "http://foo.json",
            Ahub::APIResourceTester.admin_headers,
          ).and_return({list:[
            {id:1}, {id:2}, {id:3}
          ]}.to_json)

        resources = Ahub::APIResourceTester.get_resources(
          url: 'http://foo.json',
          headers: Ahub::APIResourceTester.admin_headers,
          klass: Ahub::APIResourceTester
        )

        (0..2).each do |index|
          expect(resources[index]).to be_a(Ahub::APIResourceTester)
          expect(resources[index].id).to be(index+1)
        end
      end
    end
  end

  describe 'instance methdods' do
    let(:attribute_hash){ {id: 789, aCamelCasedKEY:1, bbb:2, ccc:3, predefined: 'new' }}
    let(:tester){ Ahub::APIResourceTester.new(attribute_hash) }
    let(:tester_without_id){ Ahub::APIResourceTester.new({id: nil, baz: 'blur'}) }

    describe '#initialize' do
      it 'transforms any key in the attributes hash into a property on the instance' do
        expect(tester.id).to be(789)
        expect(tester.bbb).to be(2)
        expect(tester.ccc).to be(3)
      end

      it 'transforms camel cased keys into underscored equivalents' do
        expect(tester.a_camel_cased_key).to be(1)
      end

      it 'stores attributes hash in attributes property' do
        expect(tester.attributes).to eq(attribute_hash)
      end

      it 'creates read-only properties from attributes hash' do
        expect(tester.respond_to?(:ccc=)).to be(false)
      end

      it 'maintains attr_accessor methods' do
        tester.bbb = 'bbb'
        expect(tester.bbb).to eq('bbb')
      end

      context 'when an method with the same name as an attribute exists' do
        it 'does not override the existing method' do
          expect(tester.predefined).to eq('original method')
        end

        it 'does not override an instance variable' do
          expect(tester.instance_variable_get('@predefined')).to eq('original ivar')
        end
      end
    end

    describe '#update' do
      it 'raises NotImplementedError' do
        expect{tester.update}.to raise_error(NotImplementedError)
      end
    end

    describe '#admin_headers' do
      it 'calls the ::admin_headers' do
        expect(Ahub::APIResourceTester).to receive(:admin_headers).and_return(:admin_headers)
        expect(tester.admin_headers).to be(:admin_headers)
      end
    end

    describe '#json_url' do
      it 'returns expected json url if the id exists' do
        expect(tester.json_url).to eq("#{Ahub::APIResourceTester.base_url}/789.json")
      end

      it 'returns nil if the id is missing' do
        expect(tester_without_id.json_url).to be_nil
      end
    end

    describe '#update_attribute' do
      it 'returns an error if #id is missing' do
        expect{tester_without_id.update_attribute(:foo, true)}.to raise_error('#id is required for an update')
      end

      it 'calls expected URL with correct payload when an id exists' do
        expect(RestClient).to receive(:put).with(tester.json_url, {foo:true}.to_json, Ahub::APIResourceTester.admin_headers)
        tester.update_attribute(:foo, true)
      end

      context 'when call should be made' do
        context 'when an error occurs' do
          before do
            allow(RestClient).to receive(:put).and_raise('boom')
          end

          it 'returns false if an error occurs' do
            expect(tester.update_attribute(:foo, true)).to be(false)
          end

          it 'does not update current object' do
            tester.update_attribute(:bbb, 'updated')
            expect(tester.bbb).to eq(2)
          end
        end

        context 'when call succeeds' do
          before do
            allow(RestClient).to receive(:put).and_return({foo: 'new'}.merge(attribute_hash).to_json)
          end

          it 'returns true if the call works occurs' do
            expect(tester.update_attribute(:foo, 'new')).to be(true)
          end

          it 'adds getters & setters for new attribute' do
            tester.update_attribute(:foo, 'new')
            expect(tester.foo).to eq('new')
          end

          it 'updates the ivar accordingly if the attribute already existed' do
            allow(RestClient).to receive(:put).and_return({bbb: 'updated'}.to_json)
            tester.update_attribute(:bbb, 'updated')
            expect(tester.bbb).to eq('updated')
          end

          it 'updates #attributes' do
            allow(RestClient).to receive(:put).and_return(attribute_hash.merge({bbb: 'updated'}).to_json)
            tester.update_attribute(:bbb, 'updated')
            expect(tester.attributes).to eq(attribute_hash.merge({bbb: 'updated'}))
          end
        end
      end
    end
  end
end
