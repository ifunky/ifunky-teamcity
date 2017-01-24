# Initialisation class, do not call directly - use the helper classes teamcity::agent or teamcity::server
#
# @example when declaring the class
#   class { 'template' }
#
# @param ensure Required. Must be 'present' or 'absent
# @param example_path Required.  Path to somewhere
#
# @author Dan @ iFunky.net
class teamcity () inherits teamcity::params {

  if (downcase($::osfamily) != 'windows') {
    fail 'ERROR:: This module will only work on Windows.'
  }

}
