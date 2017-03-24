module Proteus
  module ApiError
    class NonDeterministicResponse < StandardError; end
  end

  module ApiEntityError
    class EntityNotFound < StandardError; end
    class ActionNotAllowed < StandardError; end
  end
end
