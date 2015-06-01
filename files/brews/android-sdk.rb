require 'formula'

class AndroidSdk < Formula
  homepage 'http://developer.android.com/index.html'
  url 'https://dl.google.com/android/android-sdk_r24.2-macosx.zip'
  version '24.2-boxen1'
  sha256 '9e0cd4844a696c555563a2daad5ff6731a4175b7a56f00c8f8dd831dbca9511b'

  resource 'completion' do
    url 'https://raw.githubusercontent.com/CyanogenMod/android_sdk/938c8d70af7d77dfcd1defe415c1e0deaa7d301b/bash_completion/adb.bash'
    sha256 "6ae8fae2a07c7a286d440d5f5bdafdd0c208284d7c8be21a0f59d96bb7426091"
  end

  # TODO docs and platform-tools
  # See the long comment below for the associated problems
  def self.var_dirs
    %w[platforms samples temp add-ons sources system-images extras]
  end

  skip_clean var_dirs

  conflicts_with 'android-platform-tools',
    :because => "the Platform-tools are be installed as part of the SDK."

  def build_tools_version
    "22.0.1"
  end

  def install
    prefix.install 'tools', 'SDK Readme.txt' => 'README'

    %w[android ddms draw9patch emulator
    emulator-arm emulator-x86 hierarchyviewer lint mksdcard
    monitor monkeyrunner traceview].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL="#{prefix}/tools/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    %w[zipalign].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL="#{prefix}/build-tools/#{build_tools_version}/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    %w[dmtracedump etc1tool hprof-conv].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL="#{prefix}/platform-tools/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    # this is data that should be preserved across upgrades, but the Android
    # SDK isn't too smart, so we still have to symlink it back into its tree.
    %w[platforms samples temp add-ons sources system-images extras].each do |d|
      src = var/"lib/android-sdk"/d
      src.mkpath
      prefix.install_symlink src
    end

    %w[adb fastboot].each do |platform_tool|
      (bin/platform_tool).write <<-EOS.undent
        #!/bin/bash
        PLATFORM_TOOL="#{prefix}/platform-tools/#{platform_tool}"
        test -x "$PLATFORM_TOOL" && exec "$PLATFORM_TOOL" "$@"
        echo "It appears you do not have 'Android SDK Platform-tools' installed."
        echo "Use the 'android' tool to install them: "
        echo "    android update sdk --no-ui --filter 'platform-tools'"
      EOS
    end

    %w[aapt aidl dexdump dx llvm-rs-cc].each do |build_tool|
      (bin/build_tool).write <<-EOS.undent
        #!/bin/bash
        BUILD_TOOLS_VERSION='#{build_tools_version}'
        BUILD_TOOL="#{prefix}/build-tools/$BUILD_TOOLS_VERSION/#{build_tool}"
        test -x "$BUILD_TOOL" && exec "$BUILD_TOOL" "$@"
        echo "It appears you do not have 'build-tools-$BUILD_TOOLS_VERSION' installed."
        echo "Use the 'android' tool to install them: "
        echo "    android update sdk --no-ui --filter 'build-tools-$BUILD_TOOLS_VERSION'"
      EOS
    end

    bash_completion.install resource('completion').files('adb.bash' => 'adb-completion.bash')
  end

  def caveats; <<-EOS.undent
    Now run the 'android' tool to install the actual SDK stuff.
    The Android-SDK location for IDEs such as Eclipse, IntelliJ etc is:
      #{prefix}
    You will have to install the platform-tools and docs EVERY time this formula
    updates. If you want to try and fix this then see the comment in this formula.
    You may need to add the following to your .bashrc:
      export ANDROID_HOME=#{opt_prefix}
    EOS
  end

  # The 'android' tool insists on deleting #{prefix}/platform-tools
  # and then installing the new one. So it is impossible for us to redirect
  # the SDK location to var so that the platform-tools don't have to be
  # freshly installed EVERY DANG time the base SDK updates.

  # Ideas: make android a script that calls the actual android tool, but after
  # that tool exits it repairs the directory locations?
end
