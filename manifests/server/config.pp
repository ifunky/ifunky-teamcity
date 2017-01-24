# == Class: teamcity::server::config
#
# Private class that deals with TeamCity configuration
#
#
class teamcity::server::config(){

  $teamCityLDAPConfigPath = "${teamcity::server::data_folder}\config\ldap-config.properties"
  $teamCityLDAPMappingPath = "${teamcity::server::data_folder}\config\ldap-mapping.xml"

  file { $teamCityLDAPConfigPath:
    ensure             => file,
    content            =>
      "# This is a sample configuration file for TeamCity LDAP integration
# To make it effective, copy it to ldap-config.properties file
# This file is overwritten with default content on each server startup.
# See documentation at http://www.jetbrains.net/confluence/display/TCD7/LDAP+Integration

# The second URL is used when the first server is down.
java.naming.provider.url=ldap://cha.rbxd.ds:389/DC=cha,DC=rbxd,DC=ds
java.naming.security.authentication=simple
java.naming.referral=follow

#####
SYNC
#####
# LDAP credentials for TeamCity plugin.
java.naming.security.principal=svc-icisextraapp006
java.naming.security.credentials=T7DrecH3

# Synchronize both users and groups. Remove obsolete TeamCity users, but don't create new ones automatically.
teamcity.auth.formatDN=cha\\\\\$login\$
teamcity.options.users.synchronize=true
teamcity.options.groups.synchronize=true
teamcity.options.createUsers=true
teamcity.options.deleteUsers=true
teamcity.options.syncTimeout=3600000

# Search users from the root: 'DC=example,DC=com'.
#teamcity.users.base=OU=Users,OU=User Accounts
teamcity.users.base=OU=User Accounts,OU=CH,OU=Markets
teamcity.users.filter=(objectClass=user)
teamcity.users.username=sAMAccountName
teamcity.users.property.displayName=displayName
teamcity.users.property.email=mail

# Search groups from 'CN=groups,DC=example,DC=com'.
teamcity.groups.base=
teamcity.groups.filter=(objectClass=group)
teamcity.groups.property.member=member

# NOTE:  EXTRA SLASH TO ESCAPE IN PUPPET!! #
#teamcity.auth.loginFilter=cha\\\\\\\\\\\\S+
#teamcity.users.login.capture=cha\\\\\\\\(.*)
# Allow user to login without requireing domain
loginFilter=.+
",
    path               => $teamCityLDAPConfigPath,
    source_permissions => ignore
  }

  file { $teamCityLDAPMappingPath:
    ensure             => file,
    content            =>
      '
<!DOCTYPE mapping SYSTEM "ldap-mapping.dtd">
<mapping>
  <!-- Example mapping entry: -->
  <group-mapping teamcityGroupKey="TEAMCITY_ADMINS" ldapGroupDn="CN=ICIS-Teamcity-Admins,OU=Access,OU=Groups,OU=CH,OU=Markets,DC=cha,DC=rbxd,DC=ds"/>
  <group-mapping teamcityGroupKey="DARWIN_USERS" ldapGroupDn="CN=ICIS-Darwin-Users,OU=Access,OU=Groups,OU=CH,OU=Markets,DC=cha,DC=rbxd,DC=ds"/>
  <group-mapping teamcityGroupKey="IDDN_USERS" ldapGroupDn="CN=ICIS-IDDN-Users,OU=Access,OU=Groups,OU=CH,OU=Markets,DC=cha,DC=rbxd,DC=ds"/>
  <group-mapping teamcityGroupKey="IEFB_USERS" ldapGroupDn="CN=ICIS-IEFB-Users,OU=Access,OU=Groups,OU=CH,OU=Markets,DC=cha,DC=rbxd,DC=ds"/>
  <group-mapping teamcityGroupKey="DASHBOARD_USERS" ldapGroupDn="CN=ICIS-Dashboard-Users,OU=Access,OU=Groups,OU=CH,OU=Markets,DC=cha,DC=rbxd,DC=ds"/>
  <group-mapping teamcityGroupKey="NAGARRO_USERS" ldapGroupDn="CN=RBI-ICIS-NagarroUsers,OU=Access,OU=Groups,OU=CH,OU=Markets,DC=cha,DC=rbxd,DC=ds"/>
</mapping>
',
    path               => $teamCityLDAPMappingPath,
    source_permissions => ignore
  }

  file { "${teamcity::server::data_folder}\config\database.properties":
    ensure  => file,
    content => template('teamcity/database.properties.erb'),
    require => File["${teamcity::server::data_folder}\config"]
  }

  download_file { "Download TeamCity Deploy Runner Plugin" :
    url                   => 'https://s3-eu-west-1.amazonaws.com/puppet-stuff/AppSoftware/TeamCity/Plugins/deploy-runner.zip',
    destination_directory => "${teamcity::server::data_folder}\Plugins",
    proxyAddress          => $teamcity::server::proxy_server,
    notify                => Service['TeamCity Service'],
    require               => File[$teamcity::server::data_folder],
  }

  download_file { "Download TeamCity Stash Plugin" :
    url                   => 'https://s3-eu-west-1.amazonaws.com/puppet-stuff/AppSoftware/TeamCity/Plugins/teamcity.stash.zip',
    destination_directory => "${teamcity::server::data_folder}\Plugins",
    proxyAddress          => $teamcity::server::proxy_server,
    notify                => Service['TeamCity Service'],
    require               => File[$teamcity::server::data_folder],
  }

# http://www.microsoft.com/en-us/download/confirmation.aspx?id=11774
  download_file { "Download TeamCity SQL Server Driver" :
    url                   => 'https://s3-eu-west-1.amazonaws.com/puppet-stuff/AppSoftware/TeamCity/Libs/sqljdbc42.jar',
    destination_directory => "${teamcity::server::data_folder}\lib\jdbc",
    proxyAddress          => $teamcity::server::proxy_server,
    notify                => Service['TeamCity Service'],
    require               => File[$teamcity::server::data_folder],
  }

  # Ensure running on the specified port
  $log_config_path = "$teamcity::server::install_folder\\conf\\server.xml"
  $p_xml = "[xml](Get-Content '${log_config_path}')"
  $connector = 'Server.Service.Connector.port'

  exec { 'Update TeamCity Port' :
    command  => "\$xml = ${p_xml}; \$xml.${connector} = \"${teamcity::server::port}\"; \$xml.save('${log_config_path}')",
    onlyif   => "\$xml = ${p_xml}; if ((\$xml.${connector}) -like \"${teamcity::server::port}\") { exit 1 }",
    notify   => Service['TeamCity Service'],
    provider => powershell,
  }

  # Configure TeamCity JVM options
  windows_env {'TEAMCITY_SERVER_MEM_OPTS':
    ensure    => present,
    value     => '-Xmx4g -XX:MaxPermSize=270m -XX:ReservedCodeCacheSize=350m',
    mergemode => clobber,
    notify    => Service['TeamCity Service'],
  }

}