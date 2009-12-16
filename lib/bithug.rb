# fix this as soon as monkey-lib has backend detection
require "monkey"
require "monkey/backend/active_support"
require "big_band"

class Bithug < BigBand
  extend Monkey::Autoloader
  class ConfigurationError < RuntimeError; end
end
