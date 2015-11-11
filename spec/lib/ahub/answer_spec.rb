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

    it 'initializes author as a Ahub::User' do
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
    it 'calls ::make_post_call' do
      response = {test:true}
      expect(Ahub::Answer).to receive(:make_post_call).with(hash_including(:url, :payload, :headers)).and_return(response)
      expect(Ahub::Answer.create(question_id:1, body:'b', username:'u', password:'p')).to eq(response)
    end
  end
end
