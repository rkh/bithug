require 'bithug'

module Bithug::Serve
  class UnknownRepositoryError < RuntimeError; end
  class ReadAccessDeniedError < RuntimeError;  end
  class WriteAccessDeniedError < RuntimeError; end
end
