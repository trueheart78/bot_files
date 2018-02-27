require 'spec_helper'

RSpec.describe BotFiles::Shell do
  include_context 'file management'
  include_context 'clean environment'

  before { ENV['SHELL'] = shell }

  describe '.name' do
    subject { described_class.name }

    context 'when zsh' do
      it { is_expected.to eq :zsh }

      let(:shell) { '/bin/zsh' }
    end

    context 'when bash' do
      it { is_expected.to eq :bash }

      let(:shell) { '/bin/bash' }
    end

    context 'when unsupported' do
      it 'raises an UnsupportedShellError' do
        expect { subject }.to raise_error BotFiles::Shell::UnsupportedShellError
      end

      junklet :shell
    end
  end

  describe '.shell_path' do
    subject { described_class.shell_path }

    context 'when zsh' do
      it 'returns the .zshrc path' do
        expect(subject).to eq BotFiles.home('.zshrc')
      end

      let(:shell) { '/bin/zsh' }
    end

    context 'when bash' do
      it 'returns the .bashrc path' do
        expect(subject).to eq BotFiles.home('.bashrc')
      end

      let(:shell) { '/bin/bash' }
    end

    context 'when unsupported' do
      it 'raises an UnsupportedShellError' do
        expect { subject }.to raise_error BotFiles::Shell::UnsupportedShellError
      end

      junklet :shell
    end
  end

  let(:shell) { '/bin/zsh' }
end
