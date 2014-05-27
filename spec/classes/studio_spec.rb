require 'spec_helper'

describe 'android::studio' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should contain_package('Android Studio').with({
      :provider => 'appdmg',
      :source   => "http://dl.google.com/android/studio/install/0.5.8/android-studio-bundle-135.1155795-mac.dmg"
    })
  end
end
