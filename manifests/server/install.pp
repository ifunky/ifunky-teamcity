class teamcity::server::install()
{

  $teamcityPackageName = $teamcity::server::package_location
  $teamcityZipFile     = "${teamcity::server::temp_dir}\\$teamcityPackageName"
  $teamcityDownloadUrl = "${teamcity::server::package_location}/$teamcityPackageName"

  notify { "cxcxcxcxcxc $teamcityDownloadUrl":}

  windows::java {'install java jre':
    update      => '51',
    arch        => $::architecture,
    type        => 'jre',
  }

  package { 'git':
    ensure          => '1.9.5.20150320',
    install_options => ["-params", '"','/GitAndUnixToolsOnPath','"'],
    provider        => 'chocolatey',
  }

  windows_env {'TEAMCITY_SERVER_OPTS':
    ensure    => present,
    value     => '-Dproxyset=true -Dhttps.proxyHost=outboundproxycha.cha.rbxd.ds -Dhttps.proxyPort=3128 -Dhttp.proxyHost=outboundproxycha.cha.rbxd.ds -Dhttp.proxyPort=3128 -Dhttp.nonProxyHosts="localhost|*.cha.rbxd.ds|*.icisextranet.ds"', mergemode => clobber,
    notify    => Service['TeamCity Service'],
  }

  windows_env {'TEAMCITY_DATA_PATH':
    ensure    => present,
    value     => $teamcity::server::data_folder,
    mergemode => clobber,
    notify    => Service['TeamCity Service'],
  }

  download_file { 'Download TeamCity' :
    url                   => $teamcityDownloadUrl,
    destination_directory => $teamcity::server::temp_dir,
    proxyAddress          => $teamcity::server::proxy_server,
  }

  windows::unzip { $teamcityZipFile:
    destination => $teamcity::server::install_folder,
    creates     => "${teamcity::server::install_folder}\conf\context.xml",
    require     => Download_file['Download TeamCity']
  }

  exec { 'Create TeamCity Service':
    command   => "new-service -name TeamCity -binaryPathName 'c:\\TeamCity\bin\\TeamCityService.exe jetservice \"/settings=c:\\TeamCity\\conf\\teamcity-server-service.xml\" \"/LogFile=c:\\TeamCity\\logs\\teamcity-winservice.log\"' -displayName 'TeamCity Server' -StartupType Automatic -Description 'JetBrains TeamCity server service (installed with Puppet)'",
    provider  => powershell,
    onlyif    => "if ((Get-Service -Name TeamCity).Name -eq 'TeamCity') { exit 1 } else { exit 0 }",
    require   => Windows::Unzip[$teamcityZipFile],
    logoutput => true,
  }

#registry::service { TeamCity:
#  ensure       => present,
#  display_name => "TeamCity Server",
#  description  => "JetBrains TeamCity server service (installed with Puppet)",
#  command      => "c:\TeamCity\bin\TeamCityService.exe\" jetservice \"/settings=c:\TeamCity\conf\teamcity-server-service.xml\" \"/LogFile=c:\TeamCity\logs\teamcity-winservice.log",
#  require      => Windows::Unzip['c:\Temp\TeamCity-8.0.2.zip']
#}

  file { $teamcity::server::data_folder:
    ensure             => directory,
    source_permissions => ignore
  }

  file { "${teamcity::server::data_folder}\config":
    ensure             => directory,
    source_permissions => ignore,
    require            => File[$teamcity::server::data_folder]
  }

  file { "${teamcity::server::data_folder}\plugins":
    ensure             => directory,
    source_permissions => ignore,
    require            => File[$teamcity::server::data_folder]
  }

  file { "${teamcity::server::data_folder}\lib":
    ensure             => directory,
    source_permissions => ignore,
    require            => File[$teamcity::server::data_folder]
  }

  file { "${teamcity::server::data_folder}\lib\jdbc":
    ensure             => directory,
    source_permissions => ignore,
    require            => File["${teamcity::server::data_folder}\lib"]
  }

}

