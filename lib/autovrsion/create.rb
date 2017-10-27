module Autovrsion
  # initializes a new git repository
  module Create
    def self.create(path)
      Rugged::Repository.init_at(path)
    end
  end
end
