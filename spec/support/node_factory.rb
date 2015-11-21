require 'ffaker'
require 'active_support/core_ext/object/try'

class NodeFactory
  @id = 0
  def self.generate_question_attributes(options={})
    node = create_json(options)
    node.merge({
      type: "question",
      title: options[:title] || "Question #{@id} Title",
      body: options[:body] || "Question #{@id} body",
      bodyAsHTML: options[:html] || "<p>Question #{@id} body</p>",
    })
  end

  def self.create_question(options={})
    Ahub::Question.new(generate_question_attributes)
  end

  def self.generate_answer_attributes(options={})
    node = create_json(options)
    node.merge({
      type: "answer",
      body: options[:body] || "Answer #{@id} body",
    })
  end

  def self.create_answer(options={})
    Ahub::Answer.new(generate_answer_attributes)
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
