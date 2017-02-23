module Proteus
  module ApiEntityError
    class EntityNotFound < StandardError; end
    class ActionNotAllowed < StandardError; end
  end
end
