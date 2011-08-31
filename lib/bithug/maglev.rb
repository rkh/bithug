require 'bithug'
require 'maglev/rchash'

unless defined? Bithug::Model
  Maglev.persistent do
    Maglev::PERSISTENT_ROOT["Bithug::Models"] ||= RCHash.new

    class Bithug::Model
      RCSet = __resolve_smalltalk_global(:RcIdentityBag)

      class RCSet
        class_primitive 'new', 'new'

        primitive '<<', 'add:'
        primitive 'push', 'add:'
        primitive 'add', 'add:'
        primitive 'size', 'size'
        primitive 'empty?', 'isEmpty'
        primitive 'each&', 'do:'
        primitive 'include?', 'includes:'
        primitive 'delete', 'removeIfPresent:'

        def all; self; end # Ohm::Set
      end

      def self.inherited(base)
        super
        maglev_persistable
      end

      def self.attribute(symbol)
        attr_accessor symbol
      end

      def self.set(symbol, klass)
        define_method symbol do
          __to_many[symbol] ||= RCSet.new
        end
      end

      def self.index(*args)
        warn "#index not implemented on MagLev (yet)"
      end

      def self.find(properties)
        
      end

      def save
        Maglev::PERSISTENT_ROOT[self.class.name]
      end

      private
      def __to_many
        @__to_many ||= {}
      end
    end
  end
else
  warn "Using MagLev, but another persistence Model is already defined!"
end
