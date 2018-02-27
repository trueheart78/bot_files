module BotFiles
  class Sources
    def initialize
      @missing = []
    end

    def missing
      @missing
    end

    def missing?(link)
      false
    end

    private

    def detect
      []
    end
  end
end
