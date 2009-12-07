require 'ohm'

module Bithug
  class User < Ohm::Model
    attribute :name
    set :following
    set :followers
    set :keys

    index :name

    def validate
      assert_present :name
    end

    def self.find(attrs, value)
      result = super(attrs, value).first || self.create(attrs.to_sym => value)
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
end