def yaml_fixture(type = :standard)
  YAML.load_file fixture_path("dotfiles/#{type}.yml")
end

def fixture_path(file)
  File.join Dir.getwd, 'spec', 'fixtures', file
end
