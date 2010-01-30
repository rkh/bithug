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
      save
    end

    def twitter_post(text)
      raise RuntimeError, "Need to authorize first!" unless twitter_client.authorized?
      twitter_client.update(text[0..139])
    end
  end
end
