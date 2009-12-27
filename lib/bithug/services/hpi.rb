module Bithug::Hpi

  class Repository
    include Bithug::Repository
    include Bithug::Repositories::Svn
    include Bithug::Repositories::Git
  end

  class User
    include Bithug::User
    include Bithug::Authentication::Local
    include Bithug::Authentication::LDAP
    include Bithug::Authentication::Kerberos

    def email
      "#{name}@hpi.uni-potsdam.de"
    end
  end
end
