class teamcity::agent::service {

  include ::teamcity::agent

  $agent_name   = $teamcity::agent::agent_name

  notify { "AGENT DAN: $agent_name": }

  service { 'TCBuildAgent':
    name   => $agent_name,
    ensure => running
  }
}