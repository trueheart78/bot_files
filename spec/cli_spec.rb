require 'spec_helper'

RSpec.describe BotFiles::CLI do
  describe 'public methods' do
    subject { described_class.new }

    it { is_expected.to respond_to :init }
    it { is_expected.to respond_to :import }
    it { is_expected.to respond_to :audit }
    it { is_expected.to respond_to :scan }
    it { is_expected.to respond_to :install }
  end

  describe '#init' do
    subject { capture_output { described_class.new.init } }

    it 'outputs the expected content' do
      is_expected.to eq 'Init 🔥'.colorize(BotFiles::Theme.on_fire) + "\n"
    end
  end

  describe '#import' do
    subject { capture_output { described_class.new.import } }

    it 'outputs the expected content' do
      is_expected.to eq 'Import 🔥'.colorize(BotFiles::Theme.on_fire) + "\n"
    end
  end

  describe '#audit' do
    subject { capture_output { described_class.new.audit } }

    it 'outputs the expected content' do
      is_expected.to eq 'Audit 🔥'.colorize(BotFiles::Theme.on_fire) + "\n"
    end
  end

  describe '#scan' do
    subject { capture_output { described_class.new.scan } }

    it 'outputs the expected content' do
      is_expected.to eq 'Scan 🔥'.colorize(BotFiles::Theme.on_fire) + "\n"
    end
  end

  describe '#install' do
    subject { capture_output { described_class.new.install } }

    it 'outputs the expected content' do
      is_expected.to eq 'Install 🔥'.colorize(BotFiles::Theme.on_fire) + "\n"
    end
  end
end
