module Bithug
  
  class PublicKey
    
    include DataMapper::Resource
    
    property :content, String, :key => true
    belongs_to :owner, :class_name => 'User'

  end
  
end
