require "bithug"

class Bithug::User < Ohm::Model
  attribute :name
  set :following
  set :followers
  set :keys, Key

  index :name

  def validate
    assert_present :name
  end

  def self.find(hash)
    result = super(hash).first || self.create(hash) 
    [result]
  end

  def == something
    if something.respond_to? :name
      return something.name == name
    else
      return false
    end
  end
end
