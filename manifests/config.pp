# Public: specify the android version and directories
class android::config {
  include homebrew

  $sdk_version = 'r22.0.1-boxen2'
  $ndk_version = 'r8e-boxen1'

  $sdk_dir = "${homebrew::config::installdir}/opt/android-sdk"
  $ndk_dir = "${homebrew::config::installdir}/opt/android-ndk"
}
