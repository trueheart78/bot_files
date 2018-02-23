module BotFiles
  class CLI < Thor
    # TODO: initialize a new dir with user input under git management (defaults to ~/dotfiles)
    #       and provide helpful details about syncing to a new repo
    # TODO: don't forget about the new config.yml file location and a default version
    desc 'init', 'create a new local repo for your dotfiles'
    def init
      puts 'Init 🔥'.colorize(Theme.on_fire)
    end

    # TODO: scan for dotfiles (ignoring bash, zsh, & other shells) and offer import with y/n confirm
    desc 'import', 'imports untracked dot files'
    def import
      puts 'Import 🔥'.colorize(Theme.on_fire)
    end

    # TODO: scan for dotfiles (ignoring bash, zsh, &l other shells)
    desc 'scan', 'scans for untracked dot files'
    def scan
      puts 'Scan 🔥'.colorize(Theme.on_fire)
    end

    # TODO: verify everything is current
    desc 'audit', 'audits existing setup'
    def audit
      puts 'Audit 🔥'.colorize(Theme.on_fire)
    end

    # TODO: setup/verify everything is current
    desc 'install', 'installs your dotfiles from the local repo'
    def install
      puts 'Install 🔥'.colorize(Theme.on_fire)
    end
  end
end
