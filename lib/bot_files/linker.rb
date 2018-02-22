module BotFiles
  class Linker
    def run
      verify_tmp_dir
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
          if link.create
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

    def verify_tmp_dir
      Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    end

    def tmp_dir
      BotFiles.home '.tmp'
    end

    def links
      return @links if @links
      @links = assignment_map.map do |f|
        Link.new f[:link_from], f[:link_to], f.fetch(:optional, false), f.fetch(:command, nil)
      end
    end

    def assignment_map
      @assignment_map ||= YAML.load_file('config.yml')[:assignment_map]
    end
  end
end
