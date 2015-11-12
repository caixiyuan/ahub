module Ahub
  module ClassHelpers
    def update
      raise NotImplementedError
    end

    def destroy
      raise NotImplementedError
    end

    def initialize(attrs)
      attrs.each_pair do |k,v|
        self.instance_variable_set("@#{k.to_s.underscore}", v)

        self.class.send(:define_method, k.to_s.underscore.to_sym) do
          instance_variable_get("@#{__method__}")
        end
      end
    end
  end
end
