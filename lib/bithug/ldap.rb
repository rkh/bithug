require 'net/ldap'
require 'bithug'

module Bithug::Ldap

  def self.connection
    @connection || setup
  end

  def self.setup(options = {})
    @connection = Net::LDAP.new :host => (options[:host] || "nads2"), :port => (options[:port] || 389)
  end

  module User
    include ServiceHelper
    class_methods do
      def authenticate(username, password)
        Bithug::Ldap.connection.auth username, password
        Bithug::Ldap.connection.bind || super
      end
    end
  end

end
