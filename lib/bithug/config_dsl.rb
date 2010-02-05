require "bithug"

class Bithug::ConfigDsl

  def initialize(env = :development)
    @environment = env.to_sym
  end

  def environment(*envs)
    yield if envs.any? { |e| e.to_sym == @environment }
    @environment
  end
  
  def map_arguments(list, *keys)
    defaults = keys.pop if keys.last.is_a? Hash
    list.inject(defaults || {}) do |hash, value|
      if value.is_a? Hash then value.inject(hash) { |h, (k, v)| h.merge k.to_sym => v }
      else hash.merge keys.shift.to_sym => value
      end
    end
  end

end
