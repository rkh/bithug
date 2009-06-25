module Bithug
  
  class User
    
    include DataMapper::Resource
    
    property :name, String, :key => true
    property :password, String
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :repositories
    #has n, :keys, :class_name => 'Bithug::PublicKey'
    
  end
  
end
