require 'spec_helper'

describe Ahub::Question do
  let(:single_response) do
    {
      id: 1,
      type: "question",
      creationDate: 1416503043934,
      creationDateFormatted: "11/20/2014 12:04 PM",
      title: "Question Title",
      body: "Question body",
      bodyAsHTML: "<p>Question body</p>",
      author: {
        id: 2,
        username: "cool_user",
        realname: "Cool User",
        reputation: 10
      }
    }
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
      list: [single_response]
    }
  end

  describe '::create' do
  end

  describe '#move' do
  end

  describe '#url' do
  end

  describe '#to_s' do
  end
end
