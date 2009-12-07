require 'bithug'

module Bithug
  module Serve
    class UnknownRepositoryError < RuntimeError; end
    class ReadAccessDeniedError < RuntimeError;  end
    class WriteAccessDeniedError < RuntimeError; end
  end
end
