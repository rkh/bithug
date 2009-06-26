module Bithug
  
  class User
    
    include DataMapper::Resource
    
    property :name, String, :key => true
    property :password, String
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :public_keys
    has n, :repositories

    alias_method :keys, :public_keys
    
  end
  
end
