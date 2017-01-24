class teamcity::service {

  service { 'TCBuildAgent':
    ensure => running
  }
}