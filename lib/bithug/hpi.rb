require "bithug"

module Bithug::Hpi
  module Repository
    include Bithug::ServiceHelper
    stack Bithug::Git::Repository, Bithug::Svn::Repository
  end

  module User
    include Bithug::ServiceHelper
    attribute :real_name
    attribute :email
    
    stack Bithug::Kerberos::User, Bithug::Local::User
    
    def self.setup(*options)
      Bithug::Local.setup(*options)
    end

  end
end
