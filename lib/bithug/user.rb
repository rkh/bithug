module Bithug
  
  class User
    
    include DataMapper::Resource
    
    property :name, String, :key => true
    property :created_at, DateTime
    property :updated_at, DateTime
    
  end
  
end