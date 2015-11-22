require 'ffaker'
require 'active_support/core_ext/object/try'

class NodeFactory
  @id = 0

  def self.create_question(options={})
    Ahub::Question.new(generate_question_attributes)
  end

  def self.create_answer(options={})
    Ahub::Answer.new(generate_answer_attributes)
  end

  def self.create_user(options={})
    Ahub::User.new(generate_user_attributes)
  end

  def self.generate_user_attributes(options={})
    @id += 1

    {
      id: @id,
      type: "user",
      creationDate: 1416502952553,
      creationDateFormatted: "11/20/2014 12:02 PM",
      modificationDate: 1447125755940,
      username: "answerhub",
      slug: "answerhub",
      avatar: "https://secure.gravatar.com/avatar/93b9bcd52a21e95be8958cbba2767742?d=identicon&r=PG",
      active: true,
      suspended: false,
      deactivated: false,
      groups: [{
        id: "2",
        creationDate: 1416502952324,
        creationDateFormatted: "11/20/2014 12:02 PM",
        modificationDate: 1416502952530,
        name: "Users"
      }],
      extraData: { }
    }

  end

  def self.generate_question_attributes(options={})
    node = generate_attributes(options)
    node.merge({
      type: "question",
      title: options[:title] || "Question #{@id} Title",
      body: options[:body] || "Question #{@id} body",
      bodyAsHTML: options[:html] || "<p>Question #{@id} body</p>",
    })
  end

  def self.generate_answer_attributes(options={})
    node = generate_attributes(options)
    node.merge({
      type: "answer",
      body: options[:body] || "Answer #{@id} body",
    })
  end

  def self.generate_multi_question_attributes(question_count=3)
    {
      name: "",
      sort: "active",
      page: 1,
      pageSize: 15,
      pageCount: 1,
      listCount: 1,
      totalCount: 1,
      sorts: ["active", "newest", "hottest"],
      list: (1..question_count).map{|q| generate_question_attributes}
    }
  end

  private

  def self.generate_attributes(options={})
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
