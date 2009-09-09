require "monk"
require "extlib"

class Monk < Thor
  
  STRING_TRANSFORMS = %w[to_s upcase downcase snake_case camel_case to_const_path to_const_string]
  
  desc "rename NAME", "rename the project to NAME"
  def rename(name)
    replacements = STRING_TRANSFORMS.inject({}) { |h, m| h.merge project_name.send(m) => name.send(m) }
    old_path_name = project_name.to_const_path
    new_path_name = name.to_const_path
    until (files = Dir.glob("*/#{old_path_name}{.*,}")).empty?
      files.each do |file|
        mv file, file.gsub(old_path_name, new_path_name) if File.exist? file
      end
    end
    Dir.glob("**/{*.rb,*.rdoc,*.ru}") do |file|
      origin = File.read file
      modified = origin.dup
      replacements.each { |args| modified.gsub!(*args) }
      if origin != modified
        say_status :modify, file
        File.open(file, "w") { |f| f << modified }
      end
    end
  end
  
  desc "name", "display the current name of the project"
  def name
    say_status :name, project_name
  end
  
  method_option :stdout, :type => :boolean, :aliases => "-o"
  desc "create TYPE NAME [PARAMETERS]", "generates a view, route, whatever"
  def create(type, name, *parameters)
    template = File.join "templates", "#{type}.erb" 
    unless File.exist? template
      say_status :error, "unknown template #{type}"
      exit 1
    end
    require "erb"
    @args, @name = parameters, name
    content = ERB.new(File.read(template), nil, "<>").result(binding)
    if options.stdout?
      puts content
    elsif File.exist? @name
      say_status :error, "File #{@name} already exists."
    else
      File.open(@name, "w") { |f| f << content }
      say_status :written, @name
    end
  end
  
  private
  
  def mv(source, target)
    FileUtils.mkdir_p File.dirname(target)
    FileUtils.mv(source, target) unless system("git mv #{source} #{target} 1>/dev/null 2>&1")
    say_status :rename, "#{source} => #{target}"
  end
  
  def project_name
    @project_name ||= begin
      $1 if File.exist? "README.rdoc" and File.open("README.rdoc") { |f| f.readline } =~ /^= *(\w+)\n?$/
    end
  end
  
end