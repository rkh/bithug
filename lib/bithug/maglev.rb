require 'bithug'
require 'maglev/rchash'

unless defined? Bithug::Model
  Bithug.maglev_persistable
  DateTime.maglev_persistable
  Date.maglev_persistable
  Rational.maglev_persistable
  
  class Bithug::Model
    maglev_persistable

    Db = (Maglev::PERSISTENT_ROOT["Bithug::Models"] ||= RCHash.new)
    RCSet = __resolve_smalltalk_global(:RcIdentityBag)

    class RCSet
      class_primitive 'new', 'new'

      primitive '<<', 'add:'
      primitive 'push', 'add:'
      primitive 'add', 'add:'
      primitive 'concat!', 'addAll:'
      primitive 'size', 'size'
      primitive 'empty?', 'isEmpty'
      primitive 'each&', 'do:'
      primitive 'collect&', 'collect:'
      primitive 'select&', 'select:'
      primitive 'map&', 'collect:'
      primitive 'findAll', 'select:'
      primitive 'include?', 'includes:'
      primitive 'delete', 'removeIfPresent:'
      primitive 'to_a', 'asArray'

      def compact; self; end
      def all; to_a; end
      def flatten; self.class.new.tap {|s| s.concat!(to_a.flatten) }; end

      def sort_by(property, options = {})
        sorted = to_a.sort_by {|a| a.send(property) }
        sorted.reverse! if options[:order] == "DESC"
        sorted
      end
    end

    def self.inherited(base)
      super
      base.name.split("::").inject(Object) do |cls, name|
        cls.const_get(name).maglev_persistable
      end
      Db[base.name] = []
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

    def self.all
      Db[self.class.name].to_a
    end

    def self.find(properties)
      Db[self.name].select do |user|
        properties.all? do |k,v|
          user.instance_variable_get("@#{k}") == v
        end
      end
    end

    attr_accessor :date_time

    def self.create(properties)
      new.tap do |o|
        properties.each do |k,v|
          o.instance_variable_set("@#{k}", v)
        end
        o.save
      end
    end

    def initialize
      @new_record = true
      self.date_time = DateTime.now
    end

    def save
      Db[self.class.name] << self if @new_record
      @new_record = false
      Maglev.commit_transaction
    end

    private
    def __to_many
      @__to_many ||= {}
    end
  end
else
  warn "Using MagLev, but another persistence Model is already defined!"
end
