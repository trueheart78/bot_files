# rubocop:disable ClassLength
module BotFiles
  class Link
    class LinkNotCreatedError < StandardError; end
    class LinkSkippedError < StandardError; end
    class CommandNotExecutedError < StandardError; end
    class DirectoryNotCreatedError < StandardError; end

    # rubocop:disable ParameterLists
    def initialize(file:, link:, optional: false, directory: nil, command: nil, system_type: nil)
      @file = file
      @link = link
      @optional = optional
      @directory = directory
      @command = command
      @system_type = system_type
    end
    # rubocop:enable ParameterLists

    def link_path
      BotFiles.home link
    end

    def file_path
      File.join BotFiles::Config.dotfile_path, file
    end

    def optional?
      @optional
    end

    def system_type
      return unless @system_type
      @system_type.downcase.to_sym
    end

    def matching_system?
      return true unless system_type
      OS.send "#{system_type}?".to_sym
    end

    def current?
      return false unless symlink?
      File.readlink(link_path) == file_path
    end

    def exists?
      return true if symlink?
      File.exist? link_path
    end

    def dir?
      return false if symlink?
      Dir.exist? link_path
    end

    def remove
      return true if exists? && File.unlink(link_path) == 1
      false
    end

    def creatable?
      directory_exists? && matching_system?
    end

    def create!
      if creatable?
        link!
      elsif optional?
        raise LinkSkippedError, 'skipped (optional)'
      elsif !matching_system?
        raise LinkSkippedError, "skipped (#{system_type}-only)"
      else
        raise LinkNotCreatedError, 'error'
      end
    end

    private

    attr_reader :file, :link

    def directory_exists?
      File.directory? File.dirname(link_path)
    end

    def link!
      symlink!
      create_directory! if directory
      execute_optional_command! if command
    end

    def symlink?
      File.symlink? link_path
    end

    def symlink!
      File.symlink file_path, link_path
    rescue Errno::ENOENT
      raise LinkNotCreatedError, 'error creating symlink'
    end

    def command
      return unless @command
      @command.gsub 'LINK_PATH', link_path
    end

    def directory
      return unless @directory
      BotFiles.home @directory
    end

    def execute_optional_command!
      raise CommandNotExecutedError, "Error executing \"#{command}\"" unless Kernel.system command
    rescue CommandNotExecutedError
      remove_symlink
      remove_directory
      raise
    end

    def create_directory!
      return if Dir.exist? directory
      raise DirectoryNotCreatedError, "Error creating \"#{directory}\"" unless Dir.mkdir directory
    rescue DirectoryNotCreatedError
      remove_symlink
      raise
    end

    def remove_symlink
      File.unlink link_path if symlink?
    end

    def remove_directory
      Dir.rmdir directory if directory && Dir.exist?(directory)
    end
  end
end
# rubocop:enable ClassLength
