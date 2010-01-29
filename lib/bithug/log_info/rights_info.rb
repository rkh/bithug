module Bithug::LogInfo
  class RightsInfo < Ohm::Model
    include LogHelper

    set :__changed_user__, Bithug::User
    set :__admin__, Bithug::User
    set :__repository__, Bithug::Repository
    attribute :date_time

    [:changed_user, :admin, :repository].each do |m|
      define_method(m) { send("__#{m}__").first }
      define_method(:"#{m}=") do |model|
        prevent_change(:"__#{m}__")
        send("__#{m}__").add(model)
        pp model
        model.rights.add(self)
      end
    end

    def was_added?
      repository.readers.all.include? changed_user
    end

    def was_removed?
      !was_added?
    end

    def was_granted_readaccess?
      was_added?
    end

    def was_granted_writeaccess?
      repository.writers.all.include? changed_user
    end
  end
end
