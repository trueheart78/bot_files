RSpec.shared_context 'clean environment' do
  after(:each) do
    ENV[BotFiles::Config::DOTFILE_PATH] = env_bak[:path]
    ENV['SHELL'] = env_bak[:shell]
  end

  let!(:env_bak) do
    {
      path: ENV.delete(BotFiles::Config::DOTFILE_PATH),
      shell: ENV.delete('SHELL')
    }
  end
end
