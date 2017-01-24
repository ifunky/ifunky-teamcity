class teamcity::server::service (){
  service { 'TeamCity Service':
    name        => 'TeamCity',
    ensure      => running,
  }
}
