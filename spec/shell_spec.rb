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
  end

  describe '.sources' do
    subject { described_class.sources }

    context 'when the path exists' do
      before do
        File.open(BotFiles.home('.zshrc'), 'w') do |f|
          source_lines.each { |s| f.puts s }
        end
      end

      context 'when source lines exist' do
        it 'returns the expected collection' do
          expect(subject).to eq expected_sources
        end

        let(:expected_sources) do
          source_lines.select { |s| s.start_with? 'source ' }
        end
        let(:source_lines) do
          [
            "source #{junk}/#{junk}",
            junk,
            'sources="x"',
            junk,
            "source #{junk}/#{junk}",
            'source_not_valid'
          ]
        end
      end

      context 'when source lines do not exist' do
        it 'returns an empty collection' do
          expect(subject).to eq []
        end

        let(:source_lines) do
          [junk, '', junk, '']
        end
      end
    end

    context 'when the path does not exist' do
      before { allow(described_class).to receive(:exist?).and_return false }

      it { is_expected.to eq [] }
    end
  end

  let(:shell) { '/bin/zsh' }
end
