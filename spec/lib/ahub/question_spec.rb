require 'ffaker'
require 'spec_helper'
require 'active_support/core_ext/object/try'

describe Ahub::Question do
  let(:answer_1_json) do
    NodeFactory.generate_answer_attributes
  end

  let(:question_1) do
    NodeFactory.create_question
  end

  let(:question_2) do
    NodeFactory.create_question
  end

  let(:question_3) do
    NodeFactory.create_question({author_id: 3, username: 'new_user'})
  end

  let(:multi_response) do
    NodeFactory.generate_multi_question_attributes(3)
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
      expect(question_1).to be_a(Ahub::APIResource)
    end

    it 'is an Ahub::Followable' do
      expect(question_1).to be_a(Ahub::Followable)
    end
  end

  describe '::create' do
    it 'calls ::create_resource' do
      response = {test:true}
      expect(Ahub::Question).to receive(:create_resource).with(hash_including(:url, :payload, :headers)).and_return(response)
      expect(Ahub::Question.create(title:'t', body:'b', topics:'', username:'u', password:'p')).to eq(response)
    end
  end

  describe '::is_question' do
    it 'returns the value of "result" from the API response' do
      allow(Ahub::Question).to receive(:get_resource).
        with(
          url: "#{Ahub::Question.base_url}/isQuestion.json?q=#{URI.encode('test title')}",
          headers: Ahub::Question.admin_headers
        ).and_return({result: true}, {result: false})

      expect(Ahub::Question.is_question(query: 'test title')).to be(true)
      expect(Ahub::Question.is_question(query: 'test title')).to be(false)
    end
  end

  describe '::find_all_by_text' do
    it 'returns an array of questions' do
      expect(Ahub::Question).to receive(:get_resources).
        with(
          url: "#{Ahub::Question.base_url}.json?q=#{URI.encode('test title')}",
          headers: Ahub::Question.admin_headers,
          klass: Ahub::Question
        ).and_return(multi_response)

      Ahub::Question.find_all_by_text(query: '  Test Title?  ')
    end
  end

  describe '::find_by_title' do
    before do
      allow(Ahub::Question).to receive(:find_all_by_text).and_return([
        question_1, question_2, question_3
      ])
    end

    it 'returns single question that whose title matches the request' do
      title = "  #{question_3.title.upcase}  \n"
      expect(Ahub::Question.find_by_title(title)).to eq(question_3)
    end

    it 'returns nil if no titles match the request' do
      expect(Ahub::Question.find_by_title('xxx')).to be_nil
    end
  end

  describe '#fetched_answers' do
    it 'returns an array of Ahub::Answer instances' do
      answer = Ahub::Answer.new(answer_1_json)
      allow(Ahub::Answer).to receive(:find).and_return(answer)

      question = Ahub::Question.new(question_1.attributes.merge(answers:[345]))

      expect(question.fetched_answers).to eq([answer])
    end
  end

  describe '#html_url' do
    it 'returns expected json url if the id exists' do
      question = Ahub::Question.new({id:123, slug:'foo-bar-baz'})
      expect(question.html_url).to eq("#{Ahub::DOMAIN}/questions/123/foo-bar-baz.html")
    end

    it 'returns expected json url if the id exists' do
      question = Ahub::Question.new({id:nil})
      expect(question.html_url).to be_nil
    end
  end

  describe '#to_s' do
    it 'returns #html_url' do
      question = Ahub::Question.new({id:1})
      expect(question.to_s).to eq(question.html_url)
    end
  end

  describe '#find_answers_by_username' do
    let!(:answers){ [NodeFactory.create_answer(username:'peter_parker'), NodeFactory.create_answer] }

    before do
      allow(question_1).to receive(:fetched_answers).and_return(answers)
    end

    it 'returns an answer object if the username matches' do
      username = answers.first.author.username
      expect(question_1.find_answers_by_username('Peter_pArker ')).to eq([answers.first])
    end

    it 'returns nil if no answer matches' do
      expect(question_1.find_answers_by_username('no one')).to eq([])
    end
  end
end
