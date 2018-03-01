require 'spec_helper'

RSpec.describe BotFiles::Linker do
  include_context 'file management'

  subject { described_class.new }

  describe '#run' do
    context 'when called' do
      before do
        allow(subject).to receive(:audit_existing_symlinks).and_return nil
        allow(subject).to receive(:create_symlinks).and_return nil
        allow(subject).to receive(:update_shells).and_return nil
      end

      it 'calls the expected methods' do
        subject.run
        expect(subject).to have_received(:audit_existing_symlinks)
        expect(subject).to have_received(:create_symlinks)
        expect(subject).to have_received(:update_shells)
      end
    end
  end
end
