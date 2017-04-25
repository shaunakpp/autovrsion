#!/usr/bin/env ruby
module Autovrsion
  class CreateRepo
    def create(path)
      repository = Rugged::Repository.init_at(path)
      puts "Repository created at directory #{path}".cyan
    end
  end
end
