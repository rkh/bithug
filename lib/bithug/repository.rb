module Bithug
  
  class Repository
    
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :members, :class_name => 'User'
    belongs_to :user, :class_name => 'User', :child_key => [:name]
    
    alias_method :owner, :user

    def update owner, name, users
      owner = User.get(owner)
      users = users.collect {|u| User.get(u)}.compact
      r = Repository.get(name) || Repository.new(:name => name)
      r.attributes = {:members => users, 
        :created_at => Time.now}
      r.save
      owner.repositories << r
      owner.save
    end
    
  end
  
end
