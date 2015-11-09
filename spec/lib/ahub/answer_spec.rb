require 'spec_helper'

describe Ahub::Answer do
  let(:answer) do
    Ahub::Answer.new({
      id: 123,
      body: 'test',
      bodyAsHTML: '<p>test</p>',
      author: {
        id: 194,
        username: "answerhub",
        reputation: 100,
      }
    })
  end

  describe '#initialize' do
    it 'has expected attributes' do
      expect(answer.id).to eq(123)
      expect(answer.body).to eq('test')
      expect(answer.body_as_html).to eq('<p>test</p>')
      expect(answer.author).to be_a(Ahub::User)
    end
  end

  describe '#user' do
    it 'returns #author' do
      expect(answer.user).to eq(answer.author)
    end
  end

  describe '#author' do
    it 'returns false for #is_complete?' do
      expect(answer.author).not_to be_is_complete
    end
  end

  describe '::create' do
    # let(:create_url){ "#{Ahub::DOMAIN}/services/v2/question/1/answer.json" }
    let(:create_url){ "http://localhost:8888/services/v2/question/1/answer.json" }

    it 'make expected call to the expected URL' do
      expect(RestClient).to receive(:post).with(
        create_url, anything, Ahub::Answer.headers(username:'u', password:'p')
      ).and_return({author: {id:2}}.to_json)

      Ahub::Answer.create({question_id:1, body:'answered!', username:'u', password:'p'})
    end

    it 'returns an Ahub::Answer instance if creation was successful' do
      allow(RestClient).to receive(:post).with(
        create_url, anything, Ahub::Answer.headers(username:'u', password:'p')
      ).and_return({author: {id:2}}.to_json)

      answer = Ahub::Answer.create({question_id:1, body:'answered!', username:'u', password:'p'})
      expect(answer).to be_a(Ahub::Answer)
    end

    it 'returns an error if a failure occurs' do
      allow(RestClient).to receive(:post).with(
        create_url, anything, Ahub::Answer.headers(username:'u', password:'p')
      ).and_raise(RestClient::InternalServerError)

      expect{Ahub::Answer.create({question_id:1, body:'answered!', username:'u', password:'p'})}.to raise_error(RestClient::InternalServerError)
    end

  end
end
