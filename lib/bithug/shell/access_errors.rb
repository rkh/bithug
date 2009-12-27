require 'bithug'

class Bithug::Shell
  class UnknownRepositoryError < RuntimeError; end
  class ReadAccessDeniedError < RuntimeError;  end
  class WriteAccessDeniedError < RuntimeError; end
end
