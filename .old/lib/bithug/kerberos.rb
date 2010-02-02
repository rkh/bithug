# On MRI, REE and Rubinius, it tries to use krb5-auth first and
# if it is unable to load krb5-auth, it tries SimpleKrb5 (FFI).
# On any other platform it is the other way around.
module Bithug::Kerberos
  module User
    include Bithug::ServiceHelper
    include Monkey::Engine

    class_methods do
      def authenticate(username, password)
        if mri? or ree? or rbx? then first, second = :krb5_auth, :simple_krb5
        else first, second = :simple_krb5, :krb5_auth
        end
        send first, username, password
      rescue LoadError
        send second, username, password
      end

      private

      def simple_krb5(username, password)
        require 'simple-krb5'
        SimpleKrb5.authenticate(username, password) || super
      end

      def krb5_auth(username, password)
        require 'krb5-auth'
        Krb5Auth::Krb5.new.get_init_creds_password(username, password)
      rescue Krb5Auth::Krb5::Exception
        super
      end
    end

  end
end
