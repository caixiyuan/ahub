module Ahub
  class ExceptionFactory
    attr_reader :orignal_exception
    def initialize(exception)
      new UnknownError(exception)

      @orignal_exception = exception
    end
  end

  class RequestError < Exception ; end
  class RedirectError < Exception ; end
  class LicenseError < Exception ; end
  class UnknownError < Exception ; end
end
