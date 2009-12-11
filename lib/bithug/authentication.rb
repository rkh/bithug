module Bithug::Authentication
  def self.new(options = {})
    type = options.delete("type") || "local"
    file = "bithug/authentication/#{type.to_const_path}"
    begin
      require file
    rescue LoadError => error
      file = type.to_const_path
      begin
        require file
      rescue LoadError
        raise error
      end
    end
    eval(file.to_const_string, TOPLEVEL_BINDING, __FILE__, __LINE__).new(options)
  end
end