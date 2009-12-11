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

  def ==(something)
    return if something.respond_to? :name
    false
  end
end
