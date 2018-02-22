require 'bundler/setup'
require 'rspec/junklet'
require 'support/simplecov'
require 'bot_files'
require 'byebug'

%w[support contexts].each do |dirname|
  Dir[File.join(File.dirname(__FILE__), dirname, '**/*.rb')].each do |file|
    require file
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
end
