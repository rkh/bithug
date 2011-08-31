source :rubygems
unless RUBY_ENGINE == "maglev"
  gem "bcrypt-ruby", "~> 3.0"
  gem "timfel-krb5-auth", :require => 'krb5_auth'
  gem "ohm"
else
  gem "bcrypt-ruby", :git => "https://github.com/timfel/bcrypt-ruby.git"
end
gem "net-ssh", "~> 2.2"

gem "big_band", :git => "https://github.com/rkh/big_band.git"
gem "monkey-lib", :git => "https://github.com/rkh/monkey-lib.git", :require => false

gem "chronic_duration"
gem "compass"
gem "extlib"
gem "haml"
gem "mime-types"
gem "oauth"
gem "sinatra"
gem "rack-contrib"
gem "ruby-hmac"
gem "twitter_oauth"
gem "yard"

group :test do
  gem "rspec"
end

platforms :jruby do
  gem "jruby-openssl"
end
