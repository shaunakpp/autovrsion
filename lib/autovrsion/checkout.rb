module Autovrsion
  # rewinds to a selected version
  class Checkout
    attr_accessor :path, :repository, :walker, :git
    def initialize(path = Dir.pwd.to_s)
      @path = path
      @repository = Rugged::Repository.new(path)
      @walker = Rugged::Walker.new(@repository)
      @git = Git.open(@path)
      @versions = []
    end

    def checkout(version_number)
      reference = @repository.head
      travel_and_reset_walker(reference.target) { |w| @versions << w.oid }
      @versions.reverse!
      git.checkout(@versions[version_number])
      display(repository.lookup(@versions[version_number]), version_number)
    rescue Rugged::OSError
      STDOUT.puts 'Path does not exist'.red
    rescue TypeError
      STDOUT.puts 'Enter Valid Version number'.red
    end

    def travel_and_reset_walker(target)
      walker.push(target)
      walker.each do |w|
        yield(w) if block_given?
      end
      walker.reset
    end

    def display(commit, version_number)
      STDOUT.puts 'Directory now at version no.' + version_number.to_s.yellow
      STDOUT.puts commit.message
      STDOUT.puts commit.type
      tree = commit.tree
      tree.each_blob { |x| STDOUT.puts x[:name].to_s.cyan }
    end

  end
end
