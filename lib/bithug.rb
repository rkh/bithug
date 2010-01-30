require "ohm"
require "monkey"
require "bithug/service_helper"

module Bithug
  extend Monkey::Autoloader
  class ConfigurationError < RuntimeError; end
  class UnknownRepositoryError < RuntimeError; end
  class ReadAccessDeniedError < RuntimeError;  end
  class WriteAccessDeniedError < RuntimeError; end

  def self.configure(&block)
    instance_yield block
  end
  
  def self.title(new_title = nil)
    @title = new_title if new_title
    @title ||= name
  end

  def self.use(service, options = {})
    service = const_get(service) unless service.is_a? Module
    options[:only]   ||= [:User, :Repository] 
    options[:except] ||= []
    ([options[:only]].flatten - [options[:except]].flatten).each do |class_name|
      if service.const_defined? class_name
        service.setup options if service.respond_to? :setup
        Bithug.const_get(class_name).send :include, service.const_get(class_name)
      else
        warn "#{service} does not offer #{class_name}"
      end
    end
  end
end
