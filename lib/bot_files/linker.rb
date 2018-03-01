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

    # rubocop:disable MethodLength
    def create_symlinks
      links.each do |link|
        print "Linking #{link.link_path}: "
        if link.dir?
          print 'skipped'
        elsif !link.current?
          if link.create!
            print 'linked'
          else
            print link.error
          end
        else
          print 'current'
        end
        print "\n"
      end
    end
    # rubocop:enable MethodLength

    def links
      return @links if @links
      @links = assignment_map.map do |f|
        Link.new f[:link_from],
                 f[:link_to],
                 optional: f.fetch(:optional, false),
                 directory: f.fetch(:directory_to_create, nil),
                 command: f.fetch(:post_install_command, nil)
      end
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
