require 'spec_helper'

RSpec.describe BotFiles::Link do
  include_context 'file management'
  before do
    allow(BotFiles::Config).to receive(:dotfile_path).and_return dotfile_path
  end
  subject { described_class.new link_params }

  describe '#link_path' do
    it 'returns the link to the path' do
      expect(subject.link_path).to eq expected_path
    end

    let(:expected_path) { BotFiles.home link }
  end

  describe '#file_path' do
    it 'returns the path to the file' do
      expect(subject.file_path).to eq expected_path
    end

    let(:expected_path) { File.join dotfile_path, file }
  end

  describe '#optional?' do
    context 'when optional is false' do
      it 'returns false' do
        expect(subject).not_to be_optional
      end

      let(:optional) { false }
    end

    context 'when optional is true' do
      it 'returns true' do
        expect(subject).to be_optional
      end

      let(:optional) { true }
    end
  end

  describe '#system_type' do
    context 'when not passed in' do
      it 'returns nil' do
        expect(subject.system_type).to eq nil
      end
    end

    context 'when passed in' do
      context 'when Mac' do
        it 'returns the expected symbolized version' do
          expect(subject.system_type).to eq :mac
        end

        let(:system_type) { 'Mac' }
      end

      context 'when Linux' do
        it 'returns the expected symbolized version' do
          expect(subject.system_type).to eq :linux
        end

        let(:system_type) { 'Linux' }
      end

      context 'when Windows' do
        it 'returns the expected symbolized version' do
          expect(subject.system_type).to eq :windows
        end

        let(:system_type) { 'Windows' }
      end
    end
  end

  describe '#matching_system?' do
    context 'when no system type is passed in' do
      it 'returns true' do
        expect(subject).to be_a_matching_system
      end
    end

    context 'when a system type is passed in' do
      before do
        allow(OS).to receive(:mac?).and_return matching_system
        allow(OS).to receive(:linux?).and_return matching_system
        allow(OS).to receive(:windows?).and_return matching_system
      end

      context 'when the system type matches' do
        context 'when Mac' do
          it 'calls the correlating method' do
            expect(OS).to receive(:mac?)
            subject.matching_system?
          end

          it 'returns true' do
            expect(subject).to be_matching_system
          end

          let(:system_type) { 'Mac' }
        end

        context 'when Linux' do
          it 'calls the correlating method' do
            expect(OS).to receive(:linux?)
            subject.matching_system?
          end

          it 'returns true' do
            expect(subject).to be_matching_system
          end

          let(:system_type) { 'Linux' }
        end

        context 'when Windows' do
          it 'calls the correlating method' do
            expect(OS).to receive(:windows?)
            subject.matching_system?
          end

          it 'returns true' do
            expect(subject).to be_matching_system
          end

          let(:system_type) { 'Mac' }

          let(:system_type) { 'Windows' }
        end

        let(:matching_system) { true }
      end

      context 'when the system type does not match' do
        it 'returns false' do
          expect(subject).not_to be_matching_system
        end

        let(:matching_system) { false }
      end

      let(:system_type) { 'Linux' }
    end
  end

  describe '#current?' do
    context 'when the link does not exist' do
      it 'returns false' do
        expect(subject).not_to be_current
      end
    end

    context 'when the link exists as a real file' do
      before { FileUtils.touch subject.link_path }

      it 'returns false' do
        expect(subject).not_to be_current
      end
    end

    context 'when the link points to a different file' do
      before { create_link other_link, subject.link_path }

      it 'returns false' do
        expect(subject).not_to be_current
      end

      let(:other_link) { BotFiles.home junk }
    end

    context 'when the link points to the right file' do
      before { create_link subject.file_path, subject.link_path }

      it 'returns true' do
        expect(subject).to be_current
      end
    end
  end

  describe '#exists?' do
    context 'when the link exists' do
      before { create_link subject.file_path, subject.link_path }

      it 'returns true' do
        expect(subject.exists?).to eq true
      end
    end

    context 'when the link does not exist' do
      it 'returns false' do
        expect(subject.exists?).to eq false
      end
    end
  end

  describe '#dir?' do
    context 'when a link' do
      before { create_link subject.file_path, subject.link_path }

      it 'returns false' do
        expect(subject).not_to be_a_dir
      end
    end

    context 'when a file' do
      before { FileUtils.touch subject.link_path }

      it 'returns false' do
        expect(subject).not_to be_a_dir
      end
    end

    context 'when a dir' do
      before { Dir.mkdir subject.link_path }

      it 'returns true' do
        expect(subject).to be_a_dir
      end
    end
  end

  describe '#remove' do
    context 'when a link exists' do
      before { create_link subject.file_path, subject.link_path }

      it 'removes the link' do
        subject.remove
        expect(subject.exists?).to eq false
      end

      it 'returns true' do
        expect(subject.remove).to eq true
      end
    end

    context 'when a link does not exist' do
      it 'returns false' do
        expect(subject.remove).to eq false
      end
    end
  end

  describe '#creatable?' do
    context 'when the directory for the link exists' do
      before { allow(subject).to receive(:system_match?).and_return system_match }

      context 'when the system type matches' do
        it 'returns true' do
          expect(subject).to be_creatable
        end

        let(:system_match) { true }
      end

      context 'when the system type does not match' do
        it 'returns false' do
          expect(subject).to be_creatable
        end

        let(:system_match) { false }
      end
    end

    context 'when the directory for the link does not exist' do
      before { remove_home_directory }

      it 'returns false' do
        expect(subject).not_to be_creatable
      end
    end
  end

  describe '#create!' do
    before do
      allow(subject).to receive(:creatable?).and_return creatable
    end

    context 'when createable' do
      it 'does not raise an error' do
        expect { subject.create! }.not_to raise_error
      end

      it 'creates the symlink' do
        subject.create!
        expect(File.symlink?(subject.link_path)).to eq true
      end

      let(:creatable) { true }
    end

    context 'when creatable with an optional command' do
      before do
        allow(Kernel).to receive(:system).with(expected_command).and_return true
      end

      it 'does not raise an error' do
        expect { subject.create! }.not_to raise_error
      end

      it 'creates the symlink' do
        subject.create!
        expect(File.symlink?(subject.link_path)).to eq true
      end

      let(:expected_command) { command.gsub 'LINK_PATH', subject.link_path }
      let(:command)          { 'sample command with LINK_PATH' }
      let(:creatable)        { true }
    end

    context 'when creatable with an optional directory' do
      before do
        allow(Dir).to receive(:mkdir).with(directory).and_return true
      end

      it 'does not raise an error' do
        expect { subject.create! }.not_to raise_error
      end

      it 'creates the symlink' do
        subject.create!
        expect(File.symlink?(subject.link_path)).to eq true
      end

      let(:creatable) { true }
    end

    context 'when creatable but symlinking fails' do
      before do
        allow(File).to receive(:symlink).and_raise expected_error
      end

      it 'raises the expected error' do
        expect { subject.create! }.to raise_error expected_error
      end

      junklet :error_message
      let(:creatable) { true }
      let(:expected_error) { described_class::LinkNotCreatedError }
    end

    context 'when creatable but the directory creation fails' do
      before { allow(Dir).to receive(:mkdir).and_return false }

      it 'removes the symlink' do
        expect { subject.create! }.to raise_error expected_error
        expect(File.symlink?(subject.link_path)).to eq false
      end

      it 'removes the directory' do
        expect { subject.create! }.to raise_error expected_error
        expect(Dir.exist?(directory_path)).to eq false
      end

      let(:directory)        { ".#{junk}" }
      let(:directory_path)   { BotFiles.home ".#{junk}" }
      let(:creatable)        { true }
      let(:expected_error)   { described_class::DirectoryNotCreatedError }
    end

    context 'when creatable but the command fails' do
      before do
        allow(Kernel).to receive(:system).with(expected_command).and_return false
      end

      it 'raises the expected error' do
        expect(Kernel).to receive(:system).with(expected_command)
        expect { subject.create! }.to raise_error expected_error
      end

      it 'removes the symlink' do
        expect { subject.create! }.to raise_error expected_error
        expect(File.symlink?(subject.link_path)).to eq false
      end

      it 'removes the directory' do
        expect { subject.create! }.to raise_error expected_error
        expect(Dir.exist?(directory_path)).to eq false
      end

      let(:expected_command) { command.gsub 'LINK_PATH', subject.link_path }
      let(:command)          { 'sample command with LINK_PATH' }
      let(:directory)        { ".#{junk}" }
      let(:directory_path)   { BotFiles.home ".#{junk}" }
      let(:creatable)        { true }
      let(:expected_error)   { described_class::CommandNotExecutedError }
    end

    context 'when not createable' do
      it 'raises an error and does not create a symlink' do
        expect { subject.create! }.to raise_error expected_error
        expect(File.symlink?(subject.link_path)).to eq false
      end

      let(:creatable)      { false }
      let(:expected_error) { described_class::LinkNotCreatedError }
    end

    context 'when optional and not createable' do
      it 'raises an error and does not create a symlink' do
        expect { subject.create! }.to raise_error expected_error
        expect(File.symlink?(subject.link_path)).to eq false
      end

      let(:creatable)      { false }
      let(:optional)       { true }
      let(:expected_error) { described_class::LinkSkippedError }
    end

    context 'when not a matching system and not createable' do
      before { allow(subject).to receive(:matching_system?).and_return false }

      it 'raises an error and does not create a symlink' do
        expect { subject.create! }.to raise_error expected_error
        expect(File.symlink?(subject.link_path)).to eq false
      end

      let(:creatable)      { false }
      let(:system_type)    { t_system_type }
      let(:expected_error) { described_class::LinkSkippedError }
    end
  end

  junklet :file, :link
  let(:optional)      { false }
  let(:command)       { nil }
  let(:directory)     { nil }
  let(:system_type)   { nil }
  let(:t_command)     { 'git config --global core.excludesfile LINK_PATH' }
  let(:t_directory)   { '.hidden_dir' }
  let(:t_system_type) { 'Linux' }
  let(:dotfile_path)  { "/#{junk}/#{junk}" }
  let(:link_params) do
    {
      file: file,
      link: link,
      optional: optional,
      directory: directory,
      command: command,
      system_type: system_type
    }
  end

  def create_link(file_path, link_path)
    File.symlink file_path, link_path
  end
end
