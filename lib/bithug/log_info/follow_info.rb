module Bithug::LogInfo
  class FollowInfo < Ohm::Model
    include LogHelper

    set :__passive_user__, Bithug::User
    set :__active_user__, Bithug::User
    attribute :__started_following__
    attribute :date_time

    [:active_user, :passive_user].each do |m|
      define_method(m) { send("__#{m}__").first }
      define_method(:"#{m}=") do |user|
        prevent_change("__#{m}__")
        send("__#{m}__").add(user)
        user.network.add(self.save)
      end
    end

    def start_following
      prevent_change(:__started_following__)
      __started_following__ = true
    end

    def stop_following
      prevent_change(:__started_following__)
      __started_following__ = false
    end

    def following?
      __started_following__ == "true"
    end
  end
end
