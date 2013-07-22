# == Class: vnc::service
#
# Manages the VNC service
#
class vnc::service {
  service { 'vncserver':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    status    => '/sbin/service vncserver status; /usr/bin/test $? -eq 0',
  }
}
