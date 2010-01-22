# fix this as soon as monkey-lib has backend detection
require "monkey"
require "ohm"
require "bithug/ext/ohm"

module Bithug
  extend Monkey::Autoloader
  class ConfigurationError < RuntimeError; end

  def self.configure(&block)
    instance_yield block
  end

  def self.use(service, options = {})
    options[:only]   ||= [:User, :Repository] 
    options[:except] ||= []
    (options[:only] - options[:except]).each do |class_name|
      if service.const_defined? class_name
        service.setup options if service.respond_to? :setup
        Bithug.const_get(class_name).send :include, service.const_get(class_name)
      else
        warn "#{service} does not offer #{class_name}"
      end
    end
  end

end
