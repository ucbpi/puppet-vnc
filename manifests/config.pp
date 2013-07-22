# == Class: vnc::config
#
# Configures the VNC Server
#
# === Note:
#
#  This class is intended to be called from the vnc class, and should not be
#  called directly
#
class vnc::config {
  include vnc

  case $::osfamily {
    'RedHat': {
      $vncservers_template = $vnc::vncservers_template
      file { '/etc/sysconfig/vncservers':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0440',
        content => template($vncservers_template),
      }

      file { '/etc/skel/.vnc':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      # drop a file in /etc/skel to setup some sane defaults for users
      $xstartup_template = $vnc::xstartup_template
      file { '/etc/skel/.vnc/xstartup':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        require => File['/etc/skel/.vnc'],
        content => template($xstartup_template),
      }
    }

    default: { }
  }
}
