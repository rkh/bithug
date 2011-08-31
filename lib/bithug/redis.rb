require "ohm"

module Bithug
  module Redis
    def self.setup(options)
      Ohm.connect(options)
    end
  end
end

unless defined? Bithug::Model
  class Bithug::Model < Ohm::Model
  end
else
  warn "Using Redis, but another persistence Model is already defined!"
end
