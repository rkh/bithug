module Bithug
  
  # This Rack middleware will reload routes files in development mode,
  # if they were changed after they have been loaded the last time.
  class Reloader
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if defined? Thread and Thread.list.size > 1 and Thread.respond_to? :exclusive
        Thread.exclusive { reload }
      else reload
      end
      @app.call(env)
    end

    def reload
      @last_load ||= {}
      Bithug::Routes.route_files.each do |file|
        mtime = File.stat(file).mtime
        @last_load[file] ||= mtime
        if @last_load[file] < mtime
          puts ">> reloading #{file}"
          $LOADED_FEATURES.delete file
          @last_load[file] = mtime
        end
        require file
      end
    end
    
  end
end