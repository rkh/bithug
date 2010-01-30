module Bithug::LogInfo
  class ForkInfo < Ohm::Model
    include LogHelper

    set :__user__, Bithug::User
    set :__fork__, Bithug::Repository
    set :__original__, Bithug::Repository

    [:user, :fork, :original].each do |m|
      define_method(m) { send("__#{m}__").first }
      define_method(:"#{m}=") do |model|
        prevent_change(:"__#{m}__")
        send("__#{m}__").add(model)
        model.forks.add(self.save)
      end
    end
  end
end
