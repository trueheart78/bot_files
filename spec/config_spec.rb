require 'spec_helper'

RSpec.describe BotFiles::Config do
  include_context 'file management'
  include_context 'clean environment'

  describe 'constants' do
    it 'has a dropbox path' do
      expect(described_class::DOTFILE_PATH).not_to be nil
    end
  end

  describe '.dotfile_path' do
    before do
      allow(BotFiles).to receive(:home).and_call_original
      allow(BotFiles).to receive(:home).with('.bot_files_config').and_return config_file
    end

    context 'when the config file exists' do
      subject { instance.dotfile_path }

      it 'returns the expected value' do
        expect(subject).to eq dotfile_path
      end

      let(:config_file) { fixture_path 'config/valid.yaml' }
    end

    context 'when the config files does not exist' do
      subject { instance.dotfile_path }

      it 'raises a ConfigNotFound error' do
        expect { subject }.to raise_error described_class::ConfigNotFound
      end

      let(:config_file) { fixture_path 'config/missing.yaml' }
    end

    context 'when the config file does not include all requirements' do
      subject { instance.dotfile_path }

      it 'raises a MissingConfigValues error' do
        expect { subject }.to raise_error described_class::MissingConfigValues
      end

      let(:config_file) { fixture_path 'config/invalid.yaml' }
    end

    let(:instance)     { Class.new(described_class).instance }
    let(:dotfile_path) { BotFiles.home 'dotfiles' }
  end
end
