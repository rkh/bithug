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
end
