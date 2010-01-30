require 'bithug'
require 'twitter_oauth'

module Bithug::Twitter

  def self.setup(options = {})
    @consumer_key = options[:consumer_key]
    @consumer_secret = options[:consumer_secret]
  end

  def self.consumer_key
    @consumer_key
  end

  def self.consumer_secret
    @consumer_secret
  end

  module User
    include Bithug::ServiceHelper
    attribute :twitter_access_token_token
    attribute :twitter_access_token_secret
    attribute :twitter_user_name

    def twitter_authorized?
      # This does no networking, so it's faster than actually 
      # asking Twitter
      twitter_authorization_requested? && twitter_user_name
    end

    def twitter_authorization_requested?
      twitter_access_token_token && twitter_access_token_secret
    end

    def twitter_clear_account
      self.twitter_access_token_token = nil
      self.twitter_user_name = nil
      self.save
    end

    def twitter_client
      TwitterOAuth::Client.new(
        :consumer_key => Bithug::Twitter.consumer_key,
        :consumer_secret => Bithug::Twitter.consumer_secret,
        :token => twitter_access_token_token,
        :secret => twitter_access_token_secret)
    end

    def twitter_request_authorization
      rt = twitter_client.request_token
      self.twitter_access_token_token = rt.token
      self.twitter_access_token_secret = rt.secret
      self.save
      rt.authorize_url
    end

    def twitter_authorize(pin)
      access_token = twitter_client.authorize(
        twitter_access_token_token,
        twitter_access_token_secret,
        :oauth_verifier => pin)
      self.twitter_access_token_token = access_token.token
      self.twitter_access_token_secret = access_token.secret
      self.twitter_user_name = access_token.params[:screen_name]
      self.save
    end

    def twitter_post(text)
      pp "Posting #{text} to Twitter for #{self.name}" 
      twitter_client.update(text[0..139]) if twitter_authorized?
    end

    # Hereafter are the hooks into the existing User and Repository methods
    # We'd probably want to be able to opt-out all of these
    def follow(user)
      twitter_post("I started following #{user.name} on Bithug")
      super
    end

    def unfollow(user)
      twitter_post("I stopped following #{user.name} on Bithug")
      super
    end

    def grant_access(options)
      twitter_post("I granted #{options[:user].name} read " +
                   "#{"and write" if options[:access] == 'w'}access " +
                   "to my repository #{options[:repo]} on Bithug!")
      super
    end

    def revoke_access(options)
      twitter_post("I revoked write #{"and read" if options[:access] == 'r'}" +
                   "access rights for #{options[:user].name} to my repository "+
                   "#{options[:repo]} on Bithug!")
      super
    end
  end

  module Repository
    include Bithug::ServiceHelper

    def fork(new_owner)
      owner.twitter_post("My project #{repo.name} on Bithug was just forked by #{new_owner.name}!")
      super
    end

    def rename_repository(new_name)
      old_name = name
      repo = super
      owner.twitter_post("I changed the name of my project #{old_name} to #{owner.name/new_name}.")
      repo
    end

    class_methods do
      def create(options = {})
        super.tap do |repo|
	  if options[:remote]
	    repo.owner.twitter_post("I just forked #{options[:name]} on Bithug.")
	  else
	    repo.owner.twitter_post("I just created #{options[:name]} on Bithug. Check it out!")
	  end
        end
      end
    end
  end
end
