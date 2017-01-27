# Private class to configure a TeamCity agent
#
#
class teamcity::agent::config
{

  include ::teamcity::agent



  # Values in the properties file must be escaped as well i.e. \\
  ini_setting { 'serverUrl':
    ensure   => present,
    path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
    section  => '',
    setting  => 'serverUrl',
    value    => $teamcity::agent::server_url,
    require  => Package['teamcityagent'],
    notify   => Service['TCBuildAgent']
  }


  #ini_setting { 'system.deploy.username':
  #  ensure   => present,
  #  path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
  #  section  => '',
  #  setting  => 'system.deploy.username',
  #  value    => 'domain\\svc-account',
  #  require  => Package['teamcityagent'],
  #  notify   => Service['TCBuildAgent']
  #}

  #ini_setting { 'system.deploy.password':
  #  ensure   => present,
  #  path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
  #  section  => '',
  #  setting  => 'system.deploy.password',
  #  value    => 'dfdf',
  #  require  => Package['teamcityagent'],
  #  notify   => Service['TCBuildAgent']
  #}

  #  Allows git agent side checkout to work
  ini_setting { 'teamcity.git.use.native.ssh':
    ensure   => present,
    path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
    section  => '',
    setting  => 'teamcity.git.use.native.ssh',
    value    => 'true',
    require  => Package['teamcityagent'],
    notify   => Service['TCBuildAgent']
  }


}