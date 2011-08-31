module Bithug::LogInfo
  class RightsInfo < Model
    include LogHelper

    attribute :access_change
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
    
    # To satisfy the "interface"
    alias user admin

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

    def to_s(mode = nil, options = {})
      "#{user.display(mode, options)} #{access_granted? ? "granted" : "removed"} " + 
      "#{access_change.end_with?("r") ? "read" : "write"} access in " +
      "#{repository.display(mode, options)} for #{changed_user.display(mode, options)}"
    end
  end
end
