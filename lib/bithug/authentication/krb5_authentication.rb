require 'krb5_auth'
#
# Add this to /etc/krb5.conf
#
# [libdefaults]
# default_realm = HPI.UNI-POTSDAM.DE
#     .
#     .
#     .
#
# [realms]
# HPI.UNI-POTSDAM.DE = {
#     kdc = 141.89.221.28
#     admin_server = 141.89.221.28
# }
#

class KerberosAuthenticationAgent
  def initialize(options=nil)
    @krb5 = Krb5Auth::Krb5.new
  end

  def authenticate(username, password)
    begin
      @ldap.get_init_creds_password(username, password)
    rescue Krb5Auth::Krb5::Exception
      false
    end
  end

  [:register, :update].each do |item|
    define_method(item) { nil }
  end
end
