# Private class that installs TeamCity and preqrequites
#
#
class teamcity::agent::install inherits teamcity::params {
  windows::java { 'install java jdk':
    update      => '51',
    arch        => $::architecture,
    type        => 'jdk',
  }

  windows::java { 'install java jre':
    update      => '51',
    arch        => $::architecture,
    type        => 'jre',
    require    => Windows::Java['install java jdk']
  }

  package { 'teamcityagent':
    ensure          => '2.0.0',
    install_options => ['-params','"',"serverurl=${teamcity_server_url}", 'agentDir=d:\TeamCity\BuildAgent','"'],
    provider        => 'chocolatey',
    require         => Windows::Java['install java jre']
  }
}
