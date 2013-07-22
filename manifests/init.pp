# == Class: vnc
#
# Installs and manages a VNC Server
#
# === Parameters
#
# [*servers*]
#   Specify an array of hashes with keys:
#     * user - username to associate with a vncserver session
#     * args - arguments to pass to this users vncserver session
#
# [*xstartup_template*]
#   specify an alternative xstartup script that will be installed to /etc/skel
#   for all NEW users
#
# [*vncservers_template*]
#   specify an alternative vncservers configuration template that will be
#   installed to /etc/sysconfig/vncservers.
#
# === Binary Requirements
#
# This class assumes that the desktop environment(s) is installed and configure
# appropriately.  The provided xstartup script assumes that gnome is the desktop
# environment.
#
# On RHEL6/CentOS6 hosts, the following package/groups are recommended:
#  $ yum groupinstall Desktop
#  $ yum install xrdb xterm
#
# === Examples
#
#  $vnc_arusso = { 'user' => 'arusso',
#                  'args' => '-SecurityTypes=VeNCrypt,TLSPlain' }
#  $vnc_brusso = { 'user' => 'brusso',
#                  'args' => '-SecurityTypes=VeNCrypt,TLSVnc' }
#  class { 'vnc':
#    servers           => [ $vnc_arusso, $vnc_brusso ],
#    xstartup_template => 'myclass/xstartup.erb',
#  }
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
class vnc (
  $servers = [ ],
  $xstartup_template = 'vnc/xstartup.erb',
  $vncservers_template = 'vnc/vncservers.erb'
) {
  include vnc::install, vnc::config, vnc::service

  Class['vnc'] ->
    Class['vnc::install'] ->
    Class['vnc::config'] ->
    Class['vnc::service']
}
