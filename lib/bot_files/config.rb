require 'singleton'

module BotFiles
  class Config
    include Singleton

    ConfigNotFound = Class.new StandardError
    MissingConfigValues = Class.new StandardError

    DOTFILE_PATH = 'DOTFILE_PATH'.freeze

    def initialize
      return if required_keys? ENV
      load_yaml
      validate_yaml
    end

    def dotfile_path
      return ENV[DOTFILE_PATH] if ENV.key? DOTFILE_PATH
      @dotfile_path ||= data[DOTFILE_PATH]
      replace_home_path if @dotfile_path.start_with? '~'
      @dotfile_path
    end

    private

    attr_reader :data

    def replace_home_path
      @dotfile_path.sub! '~', BotFiles.home_path
    end

    def config_file
      BotFiles.home '.bot_files_config'
    end

    def load_yaml
      require 'yaml'
      @data = YAML.load_file config_file if File.exist? config_file
      raise ConfigNotFound, "Unable to find #{config_file}" unless File.exist? config_file
      missing_config_error unless data
    end

    def validate_yaml
      missing_config_error unless required_keys? data
    end

    def missing_config_error
      raise MissingConfigValues,
            "Config does not have required keys: #{required_config_keys.join(', ')}"
    end

    def required_keys?(hash)
      missing_keys = required_config_keys
      required_config_keys.each do |key|
        missing_keys.delete key if hash.key? key
      end
      missing_keys.empty?
    end

    def required_config_keys
      [DOTFILE_PATH]
    end
  end
end
