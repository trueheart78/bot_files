require 'spec_helper'

RSpec.describe BotFiles::Sources do
  describe '#missing' do
    subject { described_class.new.missing }
  end

  describe '#missing?' do
    subject { described_class.new.missing? link }

    let(:link) { instance_double 'BotFiles::Link' }
  end
end
