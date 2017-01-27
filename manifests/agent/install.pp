# Private class that installs TeamCity and preqrequites
#
#
class teamcity::agent::install {

  include ::teamcity::agent

  $web_targets = [ 'C:\\Program Files (x86)\\MSBuild\\Microsoft' ]

  package { 'teamcityagent':
    ensure          => '2.0.0',
    install_options => ['-params','"',"serverurl=${teamcity::agent::server_url}","ownPort=${teamcity::agent::agent_port}","agentName=${teamcity::agent::agent_name}","agentDir=d://TeamCity//BuildAgent",'"',"--allow-empty-checksums"],
    provider        => 'chocolatey',
  }

  file { $web_targets:
    ensure             => directory,
  }

  file { 'Visual Studio Web Targets':
    ensure             => directory,
    path               => 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio',
    source             => 'puppet:///modules/teamcity/VisualStudio/',
    source_permissions => ignore,
    recurse            => true,
    require			 => File[$web_targets]
  }
}
