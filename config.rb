require 'dm-core'

Bithug.configure do
  # use Twitter, :except => Repository
  # use Ldap, :host => "ldap.com", :port => 10
  use :Hpi

  # An in-memory Sqlite3 connection:
  DataMapper.setup(:default, 'sqlite3::memory:')
  # A MySQL connection:
  #DataMapper.setup(:default, 'mysql://localhost/the_database_name')
  # A Postgres connection:
  #DataMapper.setup(:default, 'postgres://localhost/the_database_name')
end

