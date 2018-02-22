require 'yaml'
require 'fileutils'
require 'tmpdir'
require 'bot_files/version'
require 'bot_files/link'
require 'bot_files/linker'
require 'bot_files/sheller'

module BotFiles
  class << self
    def home_path
      Etc.getpwuid.dir
    end

    def home(path)
      return home_path unless path
      File.join home_path, path
    end
  end
end
