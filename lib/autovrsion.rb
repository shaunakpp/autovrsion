begin
  RUBY_VERSION =~ /(\d+.\d+)/
  require "autovrsion/#{$1}/autovrsion"
rescue LoadError
  require "autovrsion/autovrsion"
end
require 'autovrsion/create_repository'
require 'autovrsion/display_versions'
require 'autovrsion/version_checkout'
require 'autovrsion/version'
require 'autovrsion/rewind'
require 'autovrsion/reset'
require 'autovrsion/file_listener'

