module Ahub
  class ExceptionFactory
    def initialize(exception)
      new UnknownError(exception)
    end
  end

  class RequestError < Exception ; end
  class RedirectError < Exception ; end
  class LicenseError < Exception ; end
  class UnknownError < Exception ; end
end
