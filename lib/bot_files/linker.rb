module BotFiles
  class Linker
    def run
      audit_existing_symlinks
      create_symlinks
      update_shells
    end

    private

    def update_shells
      Sheller.new(dotfile_link.link_path).update_shells
    end

    def dotfile_link
      links.find_all { |l| l.file == 'dotfiles' }.first
    end

    # rubocop:disable MethodLength
    def audit_existing_symlinks
      links.each do |link|
        print "Checking #{link.link_path}: "
        if link.exists?
          if link.dir?
            print 'existing dir'
          elsif link.current?
            print 'looks good'
          elsif link.remove
            print 'removed'
          else
            print 'error'
          end
        else
          print 'not there'
        end
        print "\n"
      end
    end
    # rubocop:enable MethodLength

    def create_symlinks
      links.each do |link|
        puts "Linking #{link.link_path}: #{xxx(link)}"
      end
    end

    def xxx(link)
      return 'skipped' if link.dir?
      return 'current' if link.current?
      link.create!
    rescue catchable_errors => error
      error.message
    end

    def catchable_errors
      [
        Link::LinkNotCreatedError,
        Link::LinkSkippedError,
        Link::CommandNotExecutedError,
        Link::DirectoryNotCreatedError
      ]
    end

    def links
      @links ||= assignment_map.map { |hash| Link.new link_params(hash) }
    end

    def link_params(hash)
      {
        file: hash[:link_from],
        link: hash[:link_to],
        optional: hash.fetch(:optional, false),
        directory: hash.fetch(:directory_to_create, nil),
        command: hash.fetch(:post_install_command, nil),
        system_type: hash.fetch(:system_type, nil)
      }
    end

    def shell_directory
      {
        description: 'Aliases and functions for the shell(s)',
        link_from: 'shells',
        link_to: '.dotfile_shells'
      }
    end

    def assignment_map
      return @assignment_map if @assignment_map
      @assignment_map = YAML.load_file('config.yml')[:assignment_map]
      @assignment_map.unshift shell_directory
      @assignment_map
    end
  end
end
