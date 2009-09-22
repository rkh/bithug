require "fileutils"
require "yaml"

module Project
  module Routes
    
    def config_path(*args)
      root_path("config", *args)
    end
    
    def settings
      @settings ||= begin
        settings_file = config_path "settings.yml"
        FileUtils.cp config_path("settings.example.yml"), settings_file unless File.exist? settings_file
        YAML.load_file settings_file
      end
    end

  end
end