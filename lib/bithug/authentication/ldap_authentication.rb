require 'net/ldap'

class LDAPAuthenticationAgent
  def initialize(options)
    @ldap = Net::LDAP.new :host => "nads1",
      :port => 389
  end

  def authenticate(username, password)
    @ldap.auth username, password
    @ldap.bind
  end

  [:register, :update].each do |item|
    define_method(item) { nil }
  end
end
