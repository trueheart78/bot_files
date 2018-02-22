require 'spec_helper'

RSpec.shared_context 'file management' do
  before(:each) do
    allow(BotFiles).to receive(:home_path).and_return home_directory
  end

  after(:each) { remove_home_directory }

  def remove_home_directory
    FileUtils.rm_r(home_directory) if Dir.exist? home_directory
  end

  let(:home_directory) { Dir.mktmpdir }
end
