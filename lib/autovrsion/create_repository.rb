module Autovrsion
  # initializes a new git repository
  class CreateRepo
    def create(path)
      Rugged::Repository.init_at(path)
      puts "Repository created at directory #{path}".cyan
    end
  end
end
