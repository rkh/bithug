require "monk"
require "extlib"
require "erb"

class Monk < Thor
  
  STRING_TRANSFORMS = %w[to_s upcase downcase snake_case camel_case to_const_path to_const_string]
  TEMPLATE_SEPERATOR = /^@@\s*([^\s]+)\s*$/
  
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
    template_file = File.join "templates", "#{type}.erb" 
    unless File.exist? template_file
      say_status :error, "unknown template #{type}"
      exit 1
    end
    templates(File.read(template_file), name, *parameters).each do |file, content|
      if options.stdout?
        puts "## #{file}", content, ""
      else
        if File.exist? file
          say_status :error, "file #{file} already exists"
        else
          dir = File.dirname file
          unless File.directory? dir
            say_status :create, dir
            FileUtils.mkdir_p dir
          end
          say_status :create, file
          File.open(file, "w") { |f| f << content }
        end
      end
    end
  end
  
  desc "types", "list of available types for #$0 create"
  def types
    Dir.glob("templates/*.erb") do |template|
      say_status template[10..-5], File.read(template).split(TEMPLATE_SEPERATOR).first.strip
    end
  end
  
  private
  
  def templates(template, name, *args)
    file = nil
    output = {}
    template.split(TEMPLATE_SEPERATOR)[1..-1].each_with_index do |l, i|
      if i%2 == 0
        file = l
      else
        erb = ERB.new(l.strip, nil, "<>")
        file.gsub! ":name", name
        if file[":arg"]
          args.each { |arg| output[file.gsub(":arg", arg)] = erb.result(binding) }
        else
          output[file] = erb.result(binding)
        end
      end
    end
    output
  end
  
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