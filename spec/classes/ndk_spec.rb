require 'spec_helper'

describe 'android::ndk' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_class('android::sdk')

    should contain_homebrew__formula('android-ndk')

    should contain_package('boxen/brews/android-ndk').with_ensure('r9c-boxen1')
  end
end
