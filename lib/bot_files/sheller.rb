module BotFiles
  class Sheller
    def initialize(link_to_dotfile)
      @link_to_dotfile = link_to_dotfile
    end

    def update_shells
      update_shell(Shell.name, Shell.path) if Shell.exist?
    end

    private

    def sources(type)
      default_files(type).concat(shared_files).map { |s| source_command s }
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
      source_lines = sources type
      content = File.readlines path
      source_lines.each_with_object([]) do |line, array|
        array << line unless content.include?(line)
      end
    end

    # rubocop:disable MethodLength
    def update_shell(type, path)
      sources_to_add = missing_sources type, path
      if sources_to_add.size.zero?
        puts "Reload your #{type} shell with 'rl'"
      else
        puts "Add the following lines to #{path}"
        puts '-' * 60
        puts sources_to_add.join
        puts '-' * 60
        puts "Then reload your #{type} shell with 'source #{path}'"
        # TODO: make an output option in the YAML file for when the script is run
        #       and add this one to my own vim config
        puts 'Note: vim requires the :PlugInstall command to be run.'
      end
    end
    # rubocop:enable MethodLength
  end
end
