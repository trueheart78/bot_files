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

  describe '.path' do
    subject { described_class.path }

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

  describe '.exist?' do
    subject { described_class.exist? }

    context 'when the path exists' do
      before { FileUtils.touch BotFiles.home('.zshrc') }

      it { is_expected.to eq true }
    end

    context 'when the path does not exist' do
      it { is_expected.to eq false }
    end

    let(:shell) { '/bin/zsh' }
  end
end
