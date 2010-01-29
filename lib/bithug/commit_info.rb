module Bithug
  class CommitInfo < Ohm::Model
    attribute :message
    attribute :date_time
    attribute :revision # SHA1 Sum, Revision, whatever
    attribute :author
    attribute :email
    
    index :date_time
    index :revision
    index :author

    def author_model
      # return a temporary (not-saved) user if we cannot 
      # find a user with the given name 
      User.find(:name => author).first || User.new(:name => author)
    end

    def ==(another)
      return false unless another.is_a? self.class
      date_time == another.date_time && revision == another.revision
    end

    def hash
      # return a new hash by XOR'ing
      date_time.hash ^ revision.hash
    end
  end
end
