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

    def extract
      return unless Shell.exist?
    end

    def sources
      default_files(Shell.name).concat(shared_files).map { |s| source_command s }
    end

    def source_command(source)
      "source #{File.join(dotfile_path, source)}.sh\n"
    end

    def shared_files
      default_files 'shared'
    end

    def default_files(type)
      %w[config aliases functions].map { |f| File.join type.to_s, f }
    end

    def dotfile_path
      @dotfile_path ||= @link_to_dotfile.sub(/#{BotFiles.home_path}/, '$HOME')
    end

    def missing_sources(type, path)
      # get a collection of all sources
      source_lines = sources type
      # read the shell profile
      content = File.readlines path
      # loop through source lines
      source_lines.each_with_object([]) do |line, array|
        # if the shell profile does not have the line
        # add it to what should exist
        array << line unless content.include?(line)
      end
    end
  end
end
