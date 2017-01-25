# Private class that installs TeamCity and preqrequites
#
#
class teamcity::agent::install {

  include ::teamcity::agent

  #windows::java { 'install java jdk':
  #  update      => '51',
  #  arch        => $::architecture,
  #  type        => 'jdk',
  #}

  #windows::java { 'install java jre':
  #  update      => '51',
  #  arch        => $::architecture,
  #  type        => 'jre',
  #  require    => Windows::Java['install java jdk']
  #}

  package { 'teamcityagent':
    ensure          => '2.0.0',
    install_options => ['-params','"',"serverurl=${teamcity::agent::server_url}","ownPort=${teamcity::agent::agent_port}","agentName=${teamcity::agent::agent_name}","agentDir=d://TeamCity//BuildAgent",'"',"--allow-empty-checksums"],
    provider        => 'chocolatey',
    #require         => Windows::Java['install java jre']
  }
}
