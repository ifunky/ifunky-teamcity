# == Class: teamcity::params
#
# Default params for this module
#
#
class teamcity::params {
  $teamcity_server_url = 'http://teamcity.pra.rbxd.ds/'

  #  Agent defaults
  $agent_name          = $::hostname
  $agent_port          = 9090
  $install_dir         = 'd:\\\TeamCity\\\BuildAgent'
}