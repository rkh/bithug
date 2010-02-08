require "bithug"

class Bithug::Config

  def default_config
  end

  def initialize(env = :development)
    @environment = env.to_sym
  end

  def load_file(file)
    instance_eval File.read(file), file, 1
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
