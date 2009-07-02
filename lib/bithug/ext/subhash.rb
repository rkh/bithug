module Subhash
  def subhash(*keys)
    keys.inject({}) do |hash, key|
      hash.merge! key => self[key] if include? key
      hash
    end
  end
end

Hash.send :include, Subhash
