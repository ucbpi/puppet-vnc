# == Class: vnc::service
#
# Manages the VNC service
#
class vnc::service (
  $enable = true,
  $ensure = running,
){ 
  $notify_class = $vnc::refresh ? {
    false   => undef,
    default => Class['vnc::service'],
  }

  define vnc::create_vncserver_services (
    $servers,
    $ensure,
    $enable,
  ) {
    $index = inline_template('<%= servers.index(name) %>')
	service { "vncserver@:${index}.service":
	    ensure    => $ensure,
	    enable    => $enable,
	    hasstatus => true,
	    status    => "sudo systemctl status vncserver@:${index}.service; /usr/bin/test $? -eq 0",
	}
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^[6,5]\./: { 
		  service { 'vncserver':
		    ensure    => $ensure,
		    enable    => $enable,
		    hasstatus => true,
		    status    => '/sbin/service vncserver status; /usr/bin/test $? -eq 0',
		  }
        }
        /^7\./: {
		  vnc::create_vncserver_services {
		  	$vnc::servers:
		  		servers => $vnc::servers,
		  		ensure =>  $ensure,
		  		enable => $enable,
		  }		  
        }
        default: { fail('Unsupported OS version') }
      }
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
