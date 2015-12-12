#!/usr/bin/env ruby
class CreateRepo
	def create(path)
		repository = Rugged::Repository.init_at(path)
		STDOUT.puts "Repository created at directory #{path}".cyan
	end
end
