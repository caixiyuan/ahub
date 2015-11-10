module Ahub
  class Space
    extend Ahub::APIHelpers
    include Ahub::ClassHelpers

    attr_accessor :id, :error, :name, :active, :parent_id
    def initialize(attrs)
      @id =  attrs[:id]
      @name = attrs[:name]
      @active = attrs[:active]
      @parent_id = attrs[:parentId]
    end
  end
end
