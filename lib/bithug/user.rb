require 'ohm'

def User < Ohm::Model
  attribute :name
  index :name

  def validate
    assert_present :name
  end
end
