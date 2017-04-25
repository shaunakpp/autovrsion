#!/usr/bin/env ruby
module Autovrsion
  class Reset
    def reset(path)

      g = Git.open(path)
      g.reset
      g.checkout('master')
      puts "Repository reset to latest version".green

    end
  end
end
