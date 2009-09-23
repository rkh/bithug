def spec(file)
  system "spec #{file}" if File.exist? file
end

watch("spec/.*_spec\.rb") { |m| spec m[0] }
watch("lib/(.*)\.rb") { |m| spec "spec/#{m[1]}_spec.rb" }