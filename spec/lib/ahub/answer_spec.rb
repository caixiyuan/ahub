require 'spec_helper'

describe Ahub::Answer do
  let(:answer) do
    Ahub::Answer.new({
      id: 123,
      type: 'answer',
      body: 'test',
      bodyAsHTML: '<p>test</p>',
      author: {id: 194, username: "answerhub", reputation: 100}
    })
  end

  describe 'includes' do
    it 'should be an APIResource class' do
      expect(Ahub::Question.ancestors).to include(Ahub::APIResource)
    end

    it 'should be a Deletable class' do
      expect(Ahub::Question.ancestors).to include(Ahub::Deletable)
    end
  end

  describe '#initialize' do
    it 'is an Ahub::APIResource' do
      expect(answer).to be_a(Ahub::APIResource)
    end

    it 'has expected attributes' do
      expect(answer.id).to eq(123)
      expect(answer.body).to eq('test')
      expect(answer.body_as_html).to eq('<p>test</p>')
      expect(answer.author).to be_a(Ahub::User)
    end

    it 'initializes author as a Ahub::User' do
      expect(answer.author).to be_a(Ahub::User)
    end
  end

  describe '#user' do
    it 'returns #author' do
      expect(answer.user).to eq(answer.author)
    end
  end

  describe '#html_url' do
    it 'returns expected url' do
      expect(answer.html_url).to eq("#{Ahub::DOMAIN}/answers/#{answer.id}/view.html")
    end
  end

  describe '::create' do
    it 'calls ::create_resource' do
      response = {test:true}
      expect(Ahub::Answer).to receive(:create_resource).with(hash_including(:url, :payload, :headers)).and_return(response)
      expect(Ahub::Answer.create(question_id:1, body:'b', username:'u', password:'p')).to eq(response)
    end
  end
end
