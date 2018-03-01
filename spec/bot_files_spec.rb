require 'spec_helper'

RSpec.describe BotFiles do
  before { stub_home_path }

  it 'has a version number' do
    expect(BotFiles::VERSION).not_to be nil
  end

  describe '.home_path' do
    subject { described_class.home_path }

    it 'returns the home directory' do
      expect(subject).to eq home_directory
    end

    it 'calls Etc::Passwd' do
      expect_any_instance_of(Etc::Passwd).to receive(:dir)
      subject
    end
  end

  describe '.home' do
    subject { described_class.home path }

    context 'when provided a path' do
      it 'returns the full path' do
        expect(subject).to eq expected_path
      end

      junklet :path
      let(:expected_path) { File.join home_directory, path }
    end

    context 'when not provided a path' do
      it 'returns the home path' do
        expect(subject).to eq home_directory
      end

      let(:path) { nil }
    end
  end

  let(:home_directory) { File.join junk, junk, junk }

  def stub_home_path
    allow_any_instance_of(Etc::Passwd).to receive(:dir).and_return home_directory
  end
end
