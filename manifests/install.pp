# == Class: vnc::install
#
# Installs our vnc server packages
#
# === Note:
#
#   This class is intended to be called from the vnc class, and should not be
#   called directly
#
class vnc::install {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^6\./: { $package = 'tigervnc-server' }
        /^5\./: { $package = 'vnc-server' }
        default: { fail('Unsupported OS version') }
      }
    }
    default: {
      fail('Unsupported OS')
    }
  }

  package { $package: ensure => installed }
}
