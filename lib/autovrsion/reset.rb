#!/usr/bin/env ruby
module Autovrsion
  module Reset
    def self.reset(path)
      g = Git.open(path)
      g.reset
      g.checkout('master')
    end
  end
end
