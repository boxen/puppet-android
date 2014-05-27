# Public: Install Android Studio to /Applications
#
#
# Usage:
#
#     include android::studio
class android::studio($release = '0.4.6', $version = '133.1028713') {

  package { 'Android Studio':
    provider => 'appdmg',
    source   => "http://dl.google.com/android/studio/install/${release}/android-studio-bundle-${version}-mac.dmg"
  }
}
