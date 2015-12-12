require 'git'
require 'rugged'
require 'colored'
require 'listen'
Dir[File.expand_path('../autovrsion/*.rb', __FILE__)].each { |f| require f }
