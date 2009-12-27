module Bithug::Hpi
  class Repository
    include Bithug::Repository
    include Bithug::GitRepository
    include Bithug::SvnRepository
  end

  class User
    include Bithug::User
    include Bithug::Authentication::Kerberos
    include Bithug::Authentication::LDAP

    def email
      "#{name}@hpi.uni-potsdam.de"
    end
  end
end
