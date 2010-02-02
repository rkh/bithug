module Bithug
  module ServiceHelper
    module ClassMethods

      def postpone(*names)
        names.each { |name| eval "def #{name}(*a,&b); postponed << [__method__, a, b]; end" }
      end

      def postponed
        @postponed ||= []
      end

      def stack(*modules)
        modules.reverse_each { |m| postponed << [:include, [m], nil] }
      end

      def included(klass)
        super
        postponed.each { |m,a,b| klass.send(m, *a, &b) }
        klass.extend class_methods
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
end
