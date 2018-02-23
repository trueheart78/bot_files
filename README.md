# BotFiles

[![CircleCI](https://circleci.com/gh/trueheart78/bot_files/tree/master.svg?style=svg)](https://circleci.com/gh/trueheart78/bot_files/tree/master)

A handy little bot of a gem to help you _simply_ manage your dotfiles. Requires Ruby v2.2 or greater.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bot_files'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bot_files

## Usage

* Scaffolds a dotfile repo together with a basic structure.
* Utilizes a `~/.bot_files_config` to store a path to your dotfile repo.
* Creates a `~/.dotfiles` symlinked to the specified dotfile repo.
* Creates a `.bot_files.yml` config in your dotfile repo.

### `bot_files init`

Creates a new local repo for your dotfiles.

TODO: Write usage instructions here

### `bot_files import`

Imports untracked dot files.

TODO: Write usage instructions here

### `bot_files scan`

Scans for untracked dot files.

TODO: Write usage instructions here

### `bot_files audit`

Audits the existing setup.

TODO: Write usage instructions here

### `bot_files install`

Installs your dotfiles from the local repo

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trueheart78/bot_files. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BotFiles project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bot_files/blob/master/CODE_OF_CONDUCT.md).
