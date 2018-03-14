lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bot_files/version'

Gem::Specification.new do |spec|
  spec.name          = 'bot_files'
  spec.version       = BotFiles::VERSION
  spec.authors       = ['Josh Mills']
  spec.email         = ['josh@trueheart78.com']

  spec.summary       = 'Simple dotfiles management.'
  spec.description   = 'Simple importing and exporting of your dotfiles in your own git repo.'
  spec.homepage      = 'https://github.com/trueheart78/bot_files'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'colorize', '~> 0.8'
  spec.add_runtime_dependency 'os', "~> 1.0.0"
  spec.add_runtime_dependency 'thor', "~> 0.20"
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'pry-doc', '~> 0.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-junklet', '~> 2.2'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3.0'
  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
end
