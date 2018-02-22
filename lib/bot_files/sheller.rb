module BotFiles
  class Sheller
    class ShellBackupError < StandardError; end
    class ShellBackupUnmoveableError < StandardError; end
    class UnsupportedShellError < StandardError; end

    def initialize(link_to_dotfile)
      @link_to_dotfile = link_to_dotfile
    end

    def update_shells
      type, path = shell_file
      shell_path = File.expand_path path
      update_shell(type, shell_path) if File.exist? shell_path
    end

    private

    def shell_file
      return ['zsh', BotFiles.home('.zshrc')] if ENV['SHELL'].include? 'zsh'
      return ['bash', BotFiles.home('.bashrc')] if ENV['SHELL'].include? 'bash'
      raise UnsupportedShellError
    end

    def sources(type)
      sources = %w[zsh/config zsh/aliases zsh/functions] if type == 'zsh'
      sources = %w[vagrant/aliases vagrant/functions] if type == 'bash'
      sources.concat %w[shared/aliases shared/functions]
      sources.map { |s| "source #{File.join(dotfile_path, s)}.sh\n" }
    end

    def dotfile_path
      return @dotfile_path if @dotfile_path
      @dotfile_path = @link_to_dotfile.gsub(/#{BotFiles.home_path}/, '$HOME')
    end

    def missing_sources(type, path)
      source_lines = sources type
      content = File.readlines path
      missing_sources = source_lines.each_with_object([]) do |line, array|
        array << line unless content.include?(line)
      end
      missing_sources
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
        puts 'Note: vim requires the :PlugInstall command to be run.'
      end
    end
    # rubocop:enable MethodLength
  end
end
