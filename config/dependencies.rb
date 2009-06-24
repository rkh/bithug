require 'pathname'

module Bithug
  ROOT = Pathname(__FILE__).dirname.join('..').expand_path
  $LOAD_PATH.unshift ROOT.join("lib").to_s, *Dir.glob(ROOT.join("vendor/"))
end

%w[
  data_objects do_sqlite3
  dm-core dm-aggregates dm-migrations dm-timestamps dm-types dm-validations dm-serializer
  bithug
].each { |lib| require lib }