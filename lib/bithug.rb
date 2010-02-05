require "monkey"

module Bithug
  extend Monkey::Autoloader
  class << self
    attr_accessor :config
    def start(args = ARGV, options = {})
      Bithug::Cli.start args, options
    end
  end
end
