module Bithug::LogInfo
  class CommitInfo < Model
    include LogHelper
    attribute :message
    attribute :revision # SHA1 Sum, Revision, whatever
    attribute :author
    attribute :email

    set :__repository__, Bithug::Repository
    
    index :date_time
    index :revision
    index :author

    def repository
      __repository__.first
    end

    def repository=(repo)
      prevent_change(:__repository__)
      __repository__.add(repo)
    end

    def user
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

    def to_s(mode = nil, options = {})
      options[:message_length] ||= -1
      "#{user.display mode, options} pushed to #{repository.display mode, options}.\n" + message[0..options[:message_length]]
    end
  end
end
