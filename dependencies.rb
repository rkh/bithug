require "depgen/depgen"
class Dependencies < Depgen
  github "lsegal", "yard", :version => "0.5.3"
  github "dchelimsky", "rspec", :version => "1.3.0"
  github "rkh", "big_band", :version => "0.2.5", :git_ref => "v%s"
  github "timfel", "krb5-auth", :version => "0.8", :git_ref => "v%s"
  gem "net-ldap"
end
