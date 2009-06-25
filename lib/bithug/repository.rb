module Bithug
  
  class Repository
    
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :members, :class_name => 'User'
    belongs_to :owner, :class_name => 'User', :child_key => [:name]
    
  end
  
end
