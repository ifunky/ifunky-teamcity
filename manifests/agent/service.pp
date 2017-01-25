class teamcity::agent::service {

  include ::teamcity::agent

  service { 'TCBuildAgent':
    name   => $teamcity::agent::agent_name,
    ensure => running
  }
}