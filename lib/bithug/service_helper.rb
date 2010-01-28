require "bithug"

module Bithug::ServiceHelper
  module ClassMethods
    
    def postpone(*names)
      names.each { |name| eval "alias #{name} postponed" }
    end
    
    def postponed(*args, &block)
      if __method__.to_s == "postponed"
        @postponed ||= []
      else
        postponed << [__method__, args, block]
      end
    end
    
    def stack(*modules)
      modules.reverse_each { |m| include m }
    end
    
    def included(klass)
      super
      klass.extend class_methods
      postponed.each { |m,a,b| klass.send(m, *a, &b) }
    end
    
    def class_methods(&block)
      const_set(:ClassMethods, Module.new) unless const_defined? :ClassMethods
      @class_methods ||= const_get(:ClassMethods)
      block ? @class_methods.class_eval(&block) : @class_methods
    end
    
  end
  
  def self.included(klass)
    super
    klass.extend Bithug::ServiceHelper::ClassMethods
    klass.postpone :attribute, :set, :index
  end
  
end
