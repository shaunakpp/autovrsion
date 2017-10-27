module Autovrsion
  # Displays a listing of versions and their counts
  class Display
    attr_accessor :path, :repository, :walker
    def initialize(path = Dir.pwd.to_s)
      @path = path
      @repository = Rugged::Repository.new(@path)
      @walker = Rugged::Walker.new(@repository)
      @walker.push(@repository.head.target)
    end

    def display
      version_count = count
      walker.each_with_index do |commit, index|
        STDOUT.puts display_heading((version_count - index))
        STDOUT.puts display_commit(commit)
      end
    rescue Rugged::OSError
      STDOUT.puts 'Path does not exist'.red
    end

    private

    def count
      reset_walker
      @count ||= walker.count
      reset_walker
      @count
    end

    def reset_walker
      walker.reset
      walker.push(repository.head.target)
      walker
    end

    def display_commit(commit)
      message = ["Message: #{commit.message}"]
      file_count = 1
      commit.tree.each_blob do |file|
        message << "(#{file_count})  #{file[:name]}"
        file_count += 1
      end
      message.join("\n")
    end

    def display_heading(version_number)
      'version_number:'.yellow + version_number.to_s.cyan
    end
  end
end
