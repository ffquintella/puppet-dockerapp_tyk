#
# == Class: dockerapp_ccm
#
# Installs and configures tyk api management using docker 
#
# === Parameters
#
# [*service_name*]
#   The name of the docker service and folders to be created
#
# [*ports*]
#   Ports to be used by the app
#

class dockerapp_tyk  (
  $service_name = 'tyk',
  $version = '3.2.0',
  $ports = '8080:8080',

  ){

  include 'dockerapp'

  $dir_owner = 1
  $dir_group = 1

  $data_dir = $::dockerapp::params::data_dir
  $config_dir = $::dockerapp::params::config_dir
  $scripts_dir = $::dockerapp::params::scripts_dir
  $lib_dir = $::dockerapp::params::lib_dir
  $log_dir = $::dockerapp::params::log_dir

  $conf_datadir = "${data_dir}/${service_name}"
  $conf_configdir = "${config_dir}/${service_name}"
  $conf_scriptsdir = "${scripts_dir}/${service_name}"
  $conf_libdir = "${lib_dir}/${service_name}"
  $conf_logdir = "${log_dir}/${service_name}"

  if !defined(File[$conf_datadir]){
    file{ $conf_datadir:
      ensure  => directory,
      require => File[$data_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_configdir]){
    file{ $conf_configdir:
      ensure  => directory,
      require => File[$config_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_scriptsdir]){
    file{ $conf_scriptsdir:
      ensure  => directory,
      require => File[$scripts_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }
  if !defined(File[$conf_logdir]){
    file{ $conf_logdir:
      ensure  => directory,
      require => File[$lib_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }
  if !defined(File[$conf_libdir]){
    file{ $conf_libdir:
      ensure  => directory,
      require => File[$log_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  file{ "${conf_datadir}/apps":
    ensure  => directory,
    recurse => true,
    require => File[$conf_datadir],
    source  => 'puppet:///modules/dockerapp_tyk/apps',
  }

  file{ "${conf_datadir}/certs":
    ensure  => directory,
    recurse => true,
    require => File[$conf_datadir],
    source  => 'puppet:///modules/dockerapp_tyk/certs',
  }

  file{ "${conf_datadir}/middleware":
    ensure  => directory,
    recurse => true,
    require => File[$conf_datadir],
    source  => 'puppet:///modules/dockerapp_tyk/middleware',
  }

  file {"${conf_configdir}/docker-compose.yml":
    content => epp('dockerapp_tyk/docker-compose.yml.epp', { 
      'version' => $version, 
      'ports' => $ports, 
      'data_dir' => $conf_datadir,
      'config_dir' => $conf_configdir  }),
    notify  => Docker::Run[$service_name],
    require => File[$conf_configdir],
  }

}