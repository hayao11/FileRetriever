
module Errors
  class ErrorBaseClass < StandardError
    def initialize(arg=self.class)
      super(arg)
    end
  end
  class DangerousPathError < ErrorBaseClass; end
end
