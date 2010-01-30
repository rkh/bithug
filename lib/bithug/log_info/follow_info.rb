module Bithug::LogInfo
  class FollowInfo < Ohm::Model
    include LogHelper

    attribute :started_following
    set :__passive_user__, Bithug::User
    set :__active_user__, Bithug::User

    [:active_user, :passive_user].each do |m|
      define_method(m) { send("__#{m}__").first }
      define_method(:"#{m}=") do |user|
        prevent_change("__#{m}__")
        send("__#{m}__").add(user)
        user.network.add(self.save)
      end
    end

    def following?
      started_following == "true"
    end

    # To satisfy the "interface"
    alias user active_user
    
    def to_s
      "#{user.name} #{following? ? "start" : "stop"}ed following #{passive_user.name}"
    end
  end
end
