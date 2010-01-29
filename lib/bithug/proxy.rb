class Ohm::Model
  class << self
    alias set_without_proxy set

    def set(name, type=nil)
      set_without_proxy("__#{name}__")
      unless type.nil?
        define_method(name.to_sym) do
          Proxy.new(self.send("__#{name}__"), type)
        end 
      end
    end
  end
end

class Proxy
  def initialize(redis_collection, type)
    @collection = redis_collection
    @type = type
    @index = type.indices.first
  end

  def <<(model)
    @collection << "#{@type}:#{model.send(@index)}"
    self
  end

  alias push <<

  def all
    @collection.collect do |name|
      @type.find(@index => name).first
    end.uniq.compact
  end

  def [](idx)
    @type.find(@index => @collection[i].name).first
  end

  def first
    self.[](0)
  end

  def method_missing(*a, &b)
    @collection.send(*a, &b)
  end
end
