module BotFiles
  class Shell
    class UnsupportedShellError < StandardError; end

    class << self
      def name
        current_shell
      end

      def shell_path
        BotFiles.home current_profile
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
