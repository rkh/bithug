require 'ohm'

class User < Ohm::Model
  attribute :name
  set :keys

  index :name

  def validate
    assert_present :name
  end

  def self.find(attrs, value)
    result = super
    result << User.create(attrs => value) if result.empty? 
    result
  end
end
