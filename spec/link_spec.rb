require 'spec_helper'

RSpec.describe BotFiles::Link do
  include_context 'file management'
  subject { described_class.new file, link, optional, command }

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

    let(:expected_path) { File.join Dir.pwd, 'files', file }
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
      it 'returns true' do
        expect(subject).to be_creatable
      end
    end

    context 'when the directory for the link does not exist' do
      before { remove_home_directory }

      it 'returns false' do
        expect(subject).not_to be_creatable
      end
    end
  end

  describe '#create' do
    before do
      allow(subject).to receive(:creatable?).and_return creatable
    end

    context 'when createable' do
      it 'returns true' do
        expect(subject.create).to eq true
      end

      it 'creates the symlink' do
        subject.create
        expect(File.symlink?(subject.link_path)).to eq true
      end

      it 'does not have an error' do
        subject.create
        expect(subject.error).to eq nil
      end

      let(:creatable) { true }
    end

    context 'when creatable with an optional command' do
      before do
        allow(Kernel).to receive(:system).with(expected_command).and_return true
      end

      it 'returns true' do
        expect(subject.create).to eq true
      end

      it 'creates the symlink' do
        subject.create
        expect(File.symlink?(subject.link_path)).to eq true
      end

      it 'does not have an error' do
        subject.create
        expect(subject.error).to eq nil
      end

      let(:expected_command) { command.gsub 'LINK_PATH', subject.link_path }
      let(:command)          { 'sample command with LINK_PATH' }
      let(:creatable)        { true }
    end

    context 'when creatable but symlinking fails' do
      before do
        allow(File).to receive(:symlink).and_raise Errno::ENOENT, error_message
      end

      it 'raises the expected error' do
        expect { subject.create }.to raise_error Errno::ENOENT
      end

      junklet :error_message
      let(:creatable) { true }
    end

    context 'when creatable but the command fails' do
      before do
        allow(Kernel).to receive(:system).with(expected_command).and_return false
      end

      it 'raises the expected error' do
        expect(Kernel).to receive(:system).with(expected_command)
        expect { subject.create }.to raise_error expected_error
      end

      let(:expected_command) { command.gsub 'LINK_PATH', subject.link_path }
      let(:command)          { 'sample command with LINK_PATH' }
      let(:creatable)        { true }
      let(:expected_error)   { described_class::CommandNotExecutedError }
    end

    context 'when not createable' do
      it 'returns false' do
        expect(subject.create).to eq false
      end

      it 'does not create a symlink' do
        subject.create
        expect(File.symlink?(subject.link_path)).to eq false
      end

      it 'contains an error' do
        subject.create
        expect(subject.error).to eq 'error'
      end

      let(:creatable) { false }
    end

    context 'when optional and not createable' do
      it 'returns false' do
        expect(subject.create).to eq false
      end

      it 'does not create a symlink' do
        subject.create
        expect(File.symlink?(subject.link_path)).to eq false
      end

      it 'flags it as skipped' do
        subject.create
        expect(subject.error).to eq 'skipped (optional)'
      end

      let(:creatable) { false }
      let(:optional)  { true }
    end
  end

  junklet :file, :link

  let(:optional) { false }
  let(:command)  { nil }
  let(:t_command) do
    'git config --global core.excludesfile LINK_PATH'
  end

  def create_link(file_path, link_path)
    File.symlink file_path, link_path
  end
end
