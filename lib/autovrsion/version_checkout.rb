#!/usr/bin/env ruby
module Autovrsion
  class Checkout
    def checkout(path)
      @repo = Rugged::Repository.new(path)
      walker = Rugged::Walker.new(@repo)
      begin
        STDOUT.puts "Enter Version number"
        g = Git.open(path)
        version_number = STDIN.gets.to_i
        versions = []
        version_count = 0
        reference=@repo.head

        walker.push(reference.target)
        walker.each{ |x| version_count +=1}
        walker.reset

        walker.push(reference.target)
        walker.each { |w|
          versions[version_count] = w.oid
          version_count-=1
        }
        walker.reset
        g.checkout(versions[version_number])


        c = @repo.lookup(versions[version_number])
      rescue Rugged::OSError
        STDOUT.puts "Path does not exist".red
      rescue TypeError
        STDOUT.puts "Enter Valid Version number".red
      else
        STDOUT.puts "Directory now at version no." + " #{version_number}".yellow
        STDOUT.puts ""
        STDOUT.puts c.message
        STDOUT.puts c.type
        tree = c.tree
        tree.each_blob { |x| STDOUT.puts "#{x[:name]}".cyan }
      end

    end
  end
end
