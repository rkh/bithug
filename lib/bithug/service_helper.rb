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
      class_methods # make sure we have ClassMethods
      klass.extend ClassMethods
      postponed.each { |m,a,b| klass.send(m, *a, &b) }
    end
    
    def class_methods(&block)
      klass.const_set(:ClassMethods, Module.new) unless klass.const_defined? :ClassMethods
      ClassMethods.class_eval(&block) if block
    end
    
  end
  
  def self.included(klass)
    super
    klass.extend Bithug::ServiceHelper::ClassMethods
    klass.postpone :attribute, :set, :index
  end
  
end