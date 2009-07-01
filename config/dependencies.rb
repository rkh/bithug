require 'pathname'

module Bithug
  ROOT = Pathname(__FILE__).dirname.join('..').expand_path
  $LOAD_PATH.unshift ROOT.join("lib").to_s, *Dir.glob(ROOT.join("vendor/**/lib").to_s)
end

%w[
  dm-core dm-aggregates dm-migrations dm-timestamps dm-types dm-validations dm-serializer 
  data_objects do_sqlite3 net/ldap bcrypt
  sinatra/base grit erubis haml bithug/ext/subhash
  bithug bithug/authentication/local_authentication
  bithug/authentication/ldap_authentication 
].each { |lib| require lib }

DataMapper.setup :default, "sqlite3:///#{Bithug::ROOT}/#{Bithug.environment}.db"

Sinatra::Default.set :authentication_agent, LocalAuthenticationAgent.new
