# TeamCity server installation and configuration
#
# @example when declaring the class
#   class { 'teamcity':
#
#   }
#
# @param package_location Required. Base path to where the zip files and other installations media can be found  i.e. http://myfileserver.net/TeamCity (without a trailing slash)
# @param proxy_server Optional.  Name of the proxy server that TeamCity should use
# @param port Required.  Port number that TeamCity server interface will be exposed over, default 80
# @param install_folder Required.  TeamCity install location (not data), defaults to c:\TeamCity
# @param data_folder Required.  Location of the TeamCity  "data folder", defaults to d:\TeamCity
#
# @author Dan @ iFunky.net
class teamcity::server  (
  $package_location   = 'https://download.jetbrains.com/teamcity/TeamCity-10.0.2.exe',
  $version            = '8.0.6',
  $proxy_server       = '',
  $port               = "80",
  $install_folder     = 'C:\TeamCity',
  $data_folder        = 'D:\TeamCity',
  $db_servername      = '',
  $db_name            = 'TeamCity',
  $db_username        = 'TeamCity',
  $db_password        = 'TeamCity',
  $temp_dir           = 'c:\temp'
) {

  validate_absolute_path($install_folder)
  validate_absolute_path($data_folder)
  validate_absolute_path($temp_dir)

  if (empty($data_folder)){
    fail 'ERROR:: data_folder was not specified'
  }

  class {'teamcity::server::install':}     ->
  class {'teamcity::server::config':}      ~>
  class {'teamcity::server::service':}     ->
  Class['teamcity::server']

}
