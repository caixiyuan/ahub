require 'ffaker'
require 'spec_helper'
require 'active_support/core_ext/object/try'

class NodeFactory
  @id = 0
  def self.create_question_json(options={})
    node = create_json(options)
    node.merge({
      type: "question",
      title: options[:title] || "Question #{@id} Title",
      body: options[:body] || "Question #{@id} body",
      bodyAsHTML: options[:html] || "<p>Question #{@id} body</p>",
    })
  end

  def self.create_answer_json(options={})
    node = create_json(options)
    node.merge({
      type: "answer",
      body: options[:body] || "Answer #{@id} body",
    })
  end

  private

  def self.create_json(options={})
    @id += 1
    {
      id: @id,
      type: "question",
      creationDate: 1416503043934,
      creationDateFormatted: "11/20/2014 12:04 PM",
      author: {
        id: options[:author_id] || 2,
        username: options[:username] || "cool_user",
        realname: options[:username].try(:titleize) || "Cool User",
        reputation: 10
      }
    }
  end
end

describe Ahub::Question do
  let(:question_1_json) do
    NodeFactory.create_question_json
  end

  let(:answer_1_json) do
    NodeFactory.create_answer_json
  end

  let(:question_1) do
    Ahub::Question.new(question_1_json)
  end

  let(:question_2_json) do
    NodeFactory.create_question_json
  end

  let(:question_2) do
    Ahub::Question.new(question_2_json)
  end

  let(:question_3_json) do
    NodeFactory.create_question_json({author_id: 3, username: 'new_user'})
  end

  let(:question_3) do
    Ahub::Question.new(question_3_json)
  end

  let(:multi_response) do
    {
      name: "",
      sort: "active",
      page: 1,
      pageSize: 15,
      pageCount: 1,
      listCount: 1,
      totalCount: 1,
      sorts: ["active", "newest", "hottest"],
      list: [question_1_json, question_2_json, question_3_json]
    }
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

      Ahub::Question.find_all_by_text(query: 'test title')
    end
  end

  describe '::find_by_title' do
    before do
      allow(Ahub::Question).to receive(:find_all_by_text).and_return([
        question_1, question_2, question_3
      ])
    end
    it 'returns single question that whose title matches the request' do
      expect(Ahub::Question.find_by_title(question_3_json[:title])).to eq(question_3)
    end

    it 'returns nil if no titles match the request' do
      expect(Ahub::Question.find_by_title('xxx')).to be_nil
    end
  end

  describe '#fetched_answers' do
    it 'returns an array of Ahub::Answer instances' do
      answer = Ahub::Answer.new(answer_1_json)
      allow(Ahub::Answer).to receive(:find).and_return(answer)

      question = Ahub::Question.new(question_1_json.merge(answers:[345]))

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

  describe '#json_url' do
    it 'returns expected json url if the id exists' do
      question = Ahub::Question.new({id:123})
      expect(question.json_url).to eq("#{Ahub::Question.base_url}/123.json")
    end

    it 'returns expected json url if the id exists' do
      question = Ahub::Question.new({id:nil})
      expect(question.json_url).to be_nil
    end
  end

  describe '#to_s' do
    it 'returns #html_url' do
      question = Ahub::Question.new({id:1})
      expect(question.to_s).to eq(question.html_url)
    end
  end
end
