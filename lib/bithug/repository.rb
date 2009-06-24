module Bithug
  
  class Repository
    
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    property :created_at, DateTime
    property :updated_at, DateTime
    
  end
  
end