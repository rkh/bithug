require "bithug"

class Bithug::ConfigDsl

  def initialize(env = :development)
    @environment = env.to_sym
  end

  ##
  # @overload environment
  #   @return [Symbol]
  #     the current environment
  #
  # @overload environment(*envs)
  #   @param [Enumerable<Symbol, #to_sym>] *envs
  #     list of environments for which the given configuration should apply
  #   @yield
  #     configuration for the given envs
  def environment(*envs)
    yield if envs.any? { |e| e.to_sym == @environment }
    @environment
  end

  ##
  # @example Mapping an array
  #   map_arguments [1, 2], :foo, :bar, :blah               # => { :foo => 1,  :bar  => 2  }
  #   map_arguments [1, {:blah => 3}], :foo, :bar, :blah    # => { :foo => 1,  :blah => 2  }
  #   map_arguments [{:foo => 10}], :foo => 20, :bar => 30  # => { :foo => 10, :bar  => 30 }
  #
  # @example Using for unifying method arguments
  #   def connect(*args)
  #     options = map_arguments(args, :host, :port, :host => "localhost", :port => 80, :ssl => false)
  #     make_request options
  #   end
  #
  # @param [Enumerable<Hash, Object>] list
  #   Arguments to map
  # @param [Enumerable<#to_sym, Hash>] *keys
  #   Keys for merging list elements into the result. Last element can be a hash with default values.
  def map_arguments(list, *keys)
    defaults = keys.pop if keys.last.is_a? Hash
    list.inject(defaults || {}) do |hash, value|
      if value.is_a? Hash then value.inject(hash) { |h, (k, v)| h.merge k.to_sym => v }
      else hash.merge keys.shift.to_sym => value
      end
    end
  end

end
