module BotFiles
  class Shell
    class UnsupportedShellError < StandardError; end

    class << self
      def name
        current_shell
      end

      def path
        BotFiles.home current_profile
      end

      def exist?
        File.exist? path
      end

      def sources
        return [] unless exist?
        File.readlines(path).select { |s| s.start_with? 'source ' }.map(&:chomp)
      end

      private

      def current_profile
        supported_shells[current_shell]
      end

      def current_shell
        supported_shells.each_key do |key|
          return key if ENV['SHELL'].end_with? key.to_s
        end
        raise UnsupportedShellError
      end

      def supported_shells
        {
          zsh:  '.zshrc',
          bash: '.bashrc'
        }
      end
    end
  end
end
