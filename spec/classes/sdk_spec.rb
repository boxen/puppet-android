require 'spec_helper'

describe 'android::sdk' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do
    should include_class('android')
    should include_class('java')

    should contain_homebrew__formula('android-sdk')

    should contain_package('boxen/brews/android-sdk').with_ensure('r22.0.1-boxen2')
  end
end