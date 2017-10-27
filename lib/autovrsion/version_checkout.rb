module Autovrsion
  # rewinds to a selected version
  class Checkout
    attr_accessor :path, :repository, :walker, :git
    def initialize(path = Dir.pwd.to_s)
      @path = path
      @repository = Rugged::Repository.new(path)
      @walker = Rugged::Walker.new(@repository)
      @git = Git.open(@path)
    end

    def checkout
      STDOUT.puts 'Enter Version number'
      version_number = STDIN.gets.to_i
      versions = []
      version_count = 0
      reference = @repository.head

      walker.push(reference.target)
      walker.each { version_count += 1 }
      walker.reset

      walker.push(reference.target)
      walker.each do |w|
        versions[version_count] = w.oid
        version_count -= 1
      end
      walker.reset
      git.checkout(versions[version_number])

      commit = repository.lookup(versions[version_number])
      STDOUT.puts 'Directory now at version no.' + version_number.to_s.yellow
      STDOUT.puts commit.message
      STDOUT.puts commit.type
      tree = commit.tree
      tree.each_blob { |x| STDOUT.puts x[:name].to_s.cyan }
    rescue Rugged::OSError
      STDOUT.puts 'Path does not exist'.red
    rescue TypeError
      STDOUT.puts 'Enter Valid Version number'.red
    end
  end
end
