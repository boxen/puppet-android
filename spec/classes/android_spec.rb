require 'spec_helper'

describe 'android' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
    }
  end

  it do 
    should include_class('android::config')

    should contain_file("/opt/boxen/env.d/android.sh").with({
      :content => '# soft global overrides
[[ -z "$ANDROID_HOME" && -d "/opt/boxen/homebrew/opt/android-sdk" ]] && {
  export ANDROID_HOME=/opt/boxen/homebrew/opt/android-sdk
}
[[ -z "$ANDROID_NDK_HOME" && -d "/opt/boxen/homebrew/opt/android-ndk" ]] && {
  export ANDROID_NDK_HOME=/opt/boxen/homebrew/opt/android-ndk
}',
      :require => 'File[/opt/boxen/env.d]',
    })
  end
end