# TeamCity agent installation and configuration
#
# @example when declaring the class
#   class { 'teamcity::agent':
#     server_url = ''
#   }
#
# @param teamcity_server_url Required. TeamCity Server URL i.e. http://myteamcityserver
#
# @author Dan @ iFunky.net
class teamcity::agent (
  $server_url          = undef,
  $agent_name          = $teamcity::params::agent_name,
  $port                = $teamcity::params::agent_port
) inherits teamcity::params
{

  if(!empty($server_url)){
    validate_re($server_url, ['^(http(?:s)?\:\/\/[a-zA-Z0-9]+(?:(?:\.|\-)[a-zA-Z0-9]+)+(?:\:\d+)?(?:\/[\w\-]+)*(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)$'], 'ERROR: You must enter a TeamCirt serever url in a valid format i.e. http://teamcity.somewhere.com')
  }

  class {'teamcity::agent::install':}     ->
  class {'teamcity::agent::config':}      ~>
  class {'teamcity::agent::service':}     ->
  Class['teamcity::agent']

}
