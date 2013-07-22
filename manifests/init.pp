# == Class: vnc
#
# Installs and manages a vnc server
#
# === Parameters:
#
# [*servers*]
#   an array of hashes with keys for 'user' and 'args'.  The 'user' key will
#   denote the user that can connect to the server.  The args will provide the
#   server arguments to the vnc server.
#
# [*xstartup_template*]
#   (optional) location of the xstartup template which is installed
#   into /etc/skel for NEW users of the system.
#
# [*vncservers_template*]
#   (optional) location of the template the is used to provide the
#   /etc/sysconfig/vncserver configuration file
#
class vnc (
  $servers = [ ],
  $xstartup_template = 'vnc/xstartup.erb',
  $vncservers_template = 'vnc/vncservers.erb'
) {
  include vnc::install, vnc::config

  Class['vnc'] -> Class['vnc::install'] -> Class['vnc::config']
}
