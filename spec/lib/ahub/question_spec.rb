require 'spec_helper'

describe Ahub::Question do
  let(:index_response) do
    [single_question].to_json
  end

  let(:single_response) do
    {
      "id" => 1065,
      "type" => "question",
      "creationDate" => 1405111334000,
      "title" => "What does the function publish do?",
      "body" => "<p>other stuff</p>\n",
      "bodyAsHTML" => "<p>other stuff</p>",
      "author" => {"id" => 291, "username" => "seanb"},
      "topics" => [{
        "id" => 1062,
        "creationDate" => 1405111334000,
        "name" => "things",
        "author" => {"id" => 291, "username" => "seanb"}
      }]
    }
  end
end
