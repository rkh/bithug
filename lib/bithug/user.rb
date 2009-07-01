module Bithug
  
  class User

    include DataMapper::Resource

    property :name, String, :key => true
    property :email, String
    property :password, String
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :public_keys
    has n, :repositories

    alias_method :keys, :public_keys

    def public_key
      keys.collect do |key|
        key.content
      end.join("\n")
    end

    def password=(pw)
      attribute_set(:password, BCrypt::Password.create(pw))
    end

    def add_key(some_keys)
      some_keys.each_line do |key|
        public_keys << PublicKey.create(:content => key)
      end
      save
    end

    def update(details)
      update_attributes(details.subhash(:email, :password))
    end

  end
  
end
