module Ahub
  class Comment
    include Ahub::Followable
    include Ahub::Deletable
  end
end