require "bithug"

module Bithug::Hpi
  module Repository
    include Bithug::ServiceHelper
    stack Git::Repository, Svn::Repository
  end

  module User
    include Bithug::ServiceHelper
    attribute :real_name
    attribute :email
    
    stack Kerberos::User, Local::User
    
    def self.setup(*options)
      Local.setup(*options)
    end

  end
end
