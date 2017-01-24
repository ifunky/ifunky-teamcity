class teamcity::agent::service {

  service { 'TCBuildAgent':
    ensure => running
  }
}