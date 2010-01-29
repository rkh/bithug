module Bithug::LogInfo
  class ForkInfo < Ohm::Model
    set :__user__, Bithug::User
    set :__fork__, Bithug::Repository
    set :__original__, Bithug::Repository
    attribute :date_time

    [:user, :fork, :original].each do |m|
      define_method(m) { send("__#{m}__").first }
      define_method(:"#{m}=") do |model|
        raise RuntimeError, "Must not change logs!" unless send("__#{m}__").first.nil?
        send("__#{m}__").add(model)
        model.forks.add(self.save)
      end
    end
  end
end
