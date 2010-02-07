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

end
