# TeamCity agent installation and configuration
#
# @example when declaring the class
#   class { 'teamcity::agent':
#     teamcity_server_url = ''
#   }
#
# @param teamcity_server_url Required. TeamCity Server URL i.e. http://myteamcityserver
#
# @author Dan @ iFunky.net
class teamcity::agent (
  $teamcity_server_url)
{

  if(!empty($teamcity_server_url)){
    validate_re($teamcity_server_url, ['^(http(?:s)?\:\/\/[a-zA-Z0-9]+(?:(?:\.|\-)[a-zA-Z0-9]+)+(?:\:\d+)?(?:\/[\w\-]+)*(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)$'], 'ERROR: You must enter a TeamCirt serever url in a valid format i.e. http://teamcity.somewhere.com')
  }

  class {'teamcity::agent::install':}     ->
  class {'teamcity::agent::config':}      ~>
  class {'teamcity::agent::service':}     ->
  Class['teamcity::agent']

}
