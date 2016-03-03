require 'spec_helper'

describe Ahub::User do
  let(:user){NodeFactory.create_user}

  describe '::create' do
    let(:response){ {test:true} }
    let(:url){ Ahub::User.base_url+'.json' }

    it 'calls ::create_resource' do
      expect(Ahub::User).to receive(:create_resource).with(hash_including(:url, :payload, :headers)).and_return(response)
      expect(Ahub::User.create(username: 'u', email:'u@u.com', password: 'p')).to eq(response)
    end

    it 'uses provided password if one is present' do
      expect(Ahub::User).to receive(:create_resource).
        with(url:url, payload:{email: 'u@u.com', username: 'u', password: 'p'}, headers:Ahub::User.admin_headers)
      Ahub::User.create(username: 'u', password:'p', email:'u@u.com')
    end
  end

  describe '::find_by_username' do
    before do
      allow(RestClient).to receive(:get).with(
        "#{Ahub::User.base_url}.json",
        Ahub::User.admin_headers
        ).and_return(server_response.to_json)
    end
  end

  describe '#questions' do
    let(:questions){[NodeFactory.create_question, NodeFactory.create_question]}

    it 'calls ::get_resources the first time with expected params' do
      allow(Ahub::User).to receive(:get_resources).and_return(questions)
      expect(user.questions).to eq(questions)
    end

    it 'returns memoized questions on the second call' do
      expect(Ahub::User).to receive(:get_resources).and_return(questions).once
      user.questions
      user.questions
    end
  end

  describe '#answers' do
    let(:answers){[NodeFactory.create_answer, NodeFactory.create_answer]}

    before do
      allow(Ahub::Answer).to receive(:get_resources).and_return(answers)
    end

    it 'calls ::get_resources the first time with expected params' do
      allow(Ahub::User).to receive(:get_resources).and_return(answers)
      expect(user.answers).to eq(answers)
    end

    it 'returns memoized answers on the second call' do
      expect(Ahub::User).to receive(:get_resources).and_return(answers).once
      user.answers
      user.answers
    end
  end

  describe '#actions' do
    it 'works'
  end

  describe '#follows' do
    it 'works'
  end

  describe '#followers' do
    it 'works'
  end
end
