# == Class: vnc::config
#
# Configures the VNC Server
#
# This class should not be called directly and is called from the vnc, class.
#
# === Authors
#
# Aaron Russo <arusso@berkeley.edu>
#
# === Copyright
#
# Copyright 2013 The Regents of the University of California
# All Rights Reserved
#
class vnc::config {
  include vnc

  $notify_class = $vnc::refresh ? {
    false   => undef,
    default => Class['vnc::service'],
  }

  define vnc::create_vncserver_config (
    $servers
  ) {
    $index = inline_template('<%= servers.index(name) %>')
    $vnc_user = $name[user]

    file { "/etc/systemd/system/vncserver@:${index}.service":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0440',
      content => template($vnc::vncservers_template_systemctl),
      notify  => $notify_class,
    }
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^[6,5]\./: {    
          $vncservers_template = $vnc::vncservers_template
          file { '/etc/sysconfig/vncservers':
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => '0440',
            content => template($vncservers_template),
            notify  => $notify_class,
          }
        }
        /^7\./: {
          vnc::create_vncserver_config {
            $vnc::servers:
              servers => $vnc::servers
          }
        }
        default: { fail('Unsupported OS version') }
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

    default: { fail('Unsupported OS') }
  }
}
