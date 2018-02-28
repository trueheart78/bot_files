module BotFiles
  class Link
    attr_reader :file, :link, :files, :error

    class LinkNotCreatedError < StandardError; end
    class CommandNotExecutedError < StandardError; end
    class DirectoryNotCreatedError < StandardError; end

    def initialize(file, link, optional: false, directory: nil, command: nil)
      @files = 'files'
      @file = file
      @link = link
      @optional = optional
      @command = command
      @directory = directory
    end

    def link_path
      BotFiles.home link
    end

    def file_path
      File.join Dir.pwd, files, file
    end

    def optional?
      @optional
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
      File.directory? File.dirname(link_path)
    end

    def create
      if creatable?
        create!
        return true
      elsif optional?
        @error = 'skipped (optional)'
      else
        @error = 'error'
      end
      false
    end

    private

    def create!
      symlink!
      create_directory! if directory
      execute_optional_command! if command
    end

    def symlink?
      File.symlink? link_path
    end

    def symlink!
      File.symlink file_path, link_path
    rescue Errno::ENOENT => e
      @error = :error
      raise e
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
