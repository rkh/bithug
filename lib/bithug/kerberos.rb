require 'krb5_auth'

module Bithug::Kerberos
  module User
    include ServiceHelper

    class_methods do
      def authenticate(username, password)
        Krb5Auth::Krb5.new.get_init_creds_password(username, password)
      rescue Krb5Auth::Krb5::Exception
        super
      end
    end

  end
end
