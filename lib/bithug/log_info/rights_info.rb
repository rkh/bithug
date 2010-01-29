module Bithug::LogInfo
  class RightsInfo < Ohm::Model
    include LogHelper

    attribute :access_change
    attribute :date_time
    set :__changed_user__, Bithug::User
    set :__admin__, Bithug::User
    set :__repository__, Bithug::Repository

    [:changed_user, :admin, :repository].each do |m|
      define_method(m) { send("__#{m}__").first }
      define_method(:"#{m}=") do |model|
        prevent_change(:"__#{m}__")
        send("__#{m}__").add(model)
        model.rights.add(self)
      end
    end

    def revoke_access(access_right)
      prevent_change(:access_change)
      access_change = "-#{access_right}"
      save
    end

    def grant_access(access_right)
      prevent_change(:access_change)
      access_change = "+#{access_right}"
      save
    end

    def access_granted?
      access_change.start_with? "+"
    end

    def access_revoked?
      ! access_granted?
    end

    def writeaccess_granted?
      access_change.end_with?("w") && access_granted?
    end

    def readaccess_revoked?
      access_change.end_with?("r") && access_revoked?
    end
  end
end
