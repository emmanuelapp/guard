require 'spec_helper'

describe Guard::Notifier::NotifySend do
  let(:notifier) { described_class.new }

  before do
    stub_const 'NotifySend', stub
  end

  describe '.supported_hosts' do
    it { described_class.supported_hosts.should eq %w[linux freebsd openbsd sunos solaris] }
  end

  describe '.available?' do
    it 'checks if the binary is available' do
      described_class.should_receive(:_notifysend_binary_available?)

      described_class.should be_available
    end
  end

  describe '#notify' do
    context 'without additional options' do
      it 'shows the notification with the default options' do
        notifier.should_receive(:system).with do |command|
          command.should include("notify-send 'Welcome' 'Welcome to Guard'")
          command.should include("-i '/tmp/welcome.png'")
          command.should include("-u 'low'")
          command.should include("-t '3000'")
          command.should include("-h 'int:transient:1'")
        end

        notifier.notify('Welcome to Guard', :type => 'success', :title => 'Welcome', :image => '/tmp/welcome.png')
      end
    end

    context 'with additional options' do
      it 'can override the default options' do
        notifier.should_receive(:system).with do |command|
          command.should include("notify-send 'Waiting' 'Waiting for something'")
          command.should include("-i '/tmp/wait.png'")
          command.should include("-u 'critical'")
          command.should include("-t '5'")
        end

        notifier.notify('Waiting for something', :type => :pending, :title => 'Waiting', :image => '/tmp/wait.png',
          :t => 5,
          :u => :critical
        )
      end
    end
  end

end
