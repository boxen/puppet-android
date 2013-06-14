# Public: android::definition allows you to install a android update definition.
#
define android::definition(
  $ensure    = present,
  $dest_path = undef,
  $filter    = $title
) {
  include android::sdk

  if $dest_path == undef {
    fail('\'dest_path\' not defined')
  }

  $dest = "${android::config::sdk_dir}/${dest_path}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true,
    }
  } else {
    exec { "android-update-${filter}":
      command  => "${android::config::sdk_dir}/bin/android update sdk --all --no-ui --filter ${filter}",
      provider => 'shell',
      timeout  => 0,
      creates  => $dest,
      require  => Class['Android::Sdk'],
    }
  }
}
