# Public: Install Android Studio to /Applications
#
#
# Usage:
#
#     include android::studio
class android::studio($release = '0.5.8', $version = '135.1155795') {

  package { 'Android Studio':
    provider => 'appdmg',
    source   => "http://dl.google.com/android/studio/install/${release}/android-studio-bundle-${version}-mac.dmg"
  }
}
