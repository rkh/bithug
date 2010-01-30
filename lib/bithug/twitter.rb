require 'bithug'
require 'twitter_oauth'

module Bithug::Twitter
  attr_reader :consumer_key, :consumer_secret

  def self.setup(options = {})
    @consumer_key = options[:consumer_key]
    @consumer_secret = options[:consumer_secret]
  end

  module User
    include Bithug::ServiceHelper
    attribute :twitter_access_token_token
    attribute :twitter_access_token_secret
    attribute :twitter_user_name

    def twitter_authorized?
      # This does no networking, so it's faster than actually 
      # asking Twitter
      twitter_access_token_token && twitter_access_token_secret
    end

    def twitter_client
      TwitterOAuth::Client.new(
        :consumer_key => Bithug::Twitter.consumer_key,
        :consumer_secret => Bithug::Twitter.consumer_secret,
        :token => twitter_access_token_token,
        :secret => twitter_access_token_secret)
    end

    def twitter_request_authorization
      request_token = twitter_client.request_token
      request_token.authorize_url
    end

    def twitter_authorize(pin)
      access_token = twitter_client.authorize(
        request_token.token, 
        request_token.secret, 
        :oauth_verifier => pin)
      twitter_access_token_token = access_token.token
      twitter_access_token_secret = access_token.secret
      twitter_user_name = access_token.params[:screen_name]
      save
    end

    def twitter_post(text)
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

    def revoke_access
      twitter_post("I revoked write #{"and read" if options[:access] == 'r'}" +
                   "access rights for #{options[:user].name} to my repository "+
                   "#{options[:repo]} on Bithug!")
      super
    end
  end

  module Repository
    include Bithug::ServiceHelper

    def fork(new_owner)
      new_owner.twitter_client.update("I just forked #{repo.name} on Bithug!")
      owner.twitter_post("My project #{repo.name} on Bithug was just forked by #{new_owner.name}!")
      super
    end

    class_methods do
      def create(options = {})
        super.tap do
          owner.twitter_post("I just created #{repo.name} on Bithug. Check it out!")
        end
      end
    end
  end
end
