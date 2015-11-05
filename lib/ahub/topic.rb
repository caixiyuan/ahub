module Ahub
  class Topic
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    def initialize(attrs)
      @id = attrs[:id]
      @error = attrs[:error]
    end
  end
end
