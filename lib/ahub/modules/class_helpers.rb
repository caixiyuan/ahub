module Ahub
  module ClassHelpers
    def update
      raise NotImplementedError
    end

    def destroy
      raise NotImplementedError
    end

    def self.included(klass)
      attr_reader :id, :error
    end
  end
end
