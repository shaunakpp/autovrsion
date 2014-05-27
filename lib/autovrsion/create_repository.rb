#!/usr/bin/env ruby
require 'rugged'
require 'colored'
class CreateRepo
def create(path)
	repository = Rugged::Repository.init_at(path)
	puts "Repository created at directory #{path}".cyan
end
end