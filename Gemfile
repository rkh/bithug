source :rubygems
unless RUBY_ENGINE == "maglev"
  gem "bcrypt-ruby", "~> 3.0"
  gem "timfel-krb5-auth", :require => 'krb5_auth'
else
  gem "bcrypt-ruby", :git => "https://github.com/timfel/bcrypt-ruby.git"
end
gem "net-ssh", "~> 2.2"

platforms :jruby do
  gem "jruby-openssl"
end
