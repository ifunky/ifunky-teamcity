# Private class to configure a TeamCity agent
#
#
class teamcity::config {

  file { 'Visual Studio Web Targets':
    ensure             => directory,
    path               => 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio',
    source             => 'puppet:///modules/teamcity/VisualStudio/',
    source_permissions => ignore,
    recurse            => true,
  }

  # Values in the properties file must be escaped as well i.e. \\
  ini_setting { 'serverUrl':
    ensure   => present,
    path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
    section  => '',
    setting  => 'serverUrl',
    value    => $teamcity_server_url,
    require  => Package['teamcityagent'],
    notify   => Service['TCBuildAgent']
  }


  ini_setting { 'system.deploy.username':
    ensure   => present,
    path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
    section  => '',
    setting  => 'system.deploy.username',
    value    => 'icisextranet\\svc-icisextraapp007',
    require  => Package['teamcityagent'],
    notify   => Service['TCBuildAgent']
  }

  ini_setting { 'system.deploy.password':
    ensure   => present,
    path     => 'D:/TeamCity/BuildAgent/conf/buildAgent.properties',
    section  => '',
    setting  => 'system.deploy.password',
    value    => 'London@1',
    require  => Package['teamcityagent'],
    notify   => Service['TCBuildAgent']
  }

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