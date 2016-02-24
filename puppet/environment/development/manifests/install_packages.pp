## include puppet modules: this (also) runs 'apt-get update'
include python
include apt

class { 'nodejs':
  repo_url_suffix => 'node_5.x',
}

## variables
case $::osfamily {
  'redhat': {
    $packages_general = ['dos2unix', 'inotify-tools', 'ruby-devel']
  }
  'debian': {
    $packages_general = ['dos2unix', 'inotify-tools', 'ruby-dev']
  }
  default: {
  }
}

$packages_build_dep   = ['matplotlib', 'scikit-learn']
$packages_general_pip = [
    'redis',
    'jsonschema',
    'xmltodict',
    'six',
    'matplotlib'
]
$packages_general_npm = [
    'uglify-js',
    'imagemin',
    'node-sass',
    'babel-core',
    'browserify',
    'babelify'
]
$packages_build_size  = size($packages_build_dep) - 1

## define $PATH for all execs, and packages
Exec {
  path => ['/usr/bin/', '/bin/', '/usr/local', '/usr/sbin/', '/sbin/'],
}

## enable 'multiverse' repository (part 1, replace line)
exec {'enable-multiverse-repository-1':
  command => template('/vagrant/puppet/environment/development/template/enable_multiverse_1.erb'),
  notify  => Exec["build-package-dependencies-${packages_build_size}"],
}

## enable 'multiverse' repository (part 2, replace line)
exec {'enable-multiverse-repository-2':
  command => template('/vagrant/puppet/environment/development/template/enable_multiverse_2.erb'),
  notify  => Exec["build-package-dependencies-${packages_build_size}"],
}

## build package dependencies
each($packages_build_dep) |$index, $package| {
  exec {"build-package-dependencies-${index}":
    command     => "apt-get build-dep ${package} -y",
    before      => Package[$packages_general],
    refreshonly => true,
    timeout     => 1400,
  }
}

## packages: install general packages (apt, yum)
package {$packages_general:
  ensure => 'installed',
  before => Package[$packages_general_pip],
}

## packages: install general packages (pip)
package {$packages_general_pip:
  ensure   => 'installed',
  provider => 'pip',
  before   => Package[$packages_general_npm],
}

## packages: install general packages (npm)
package {$packages_general_npm:
  ensure   => 'present',
  provider => 'npm',
  notify   => Exec['install-babelify-presets'],
  require  => Package['npm'],
}

## packages: install babelify presets for reactjs (npm)
exec {'install-babelify-presets':
  command     => 'npm install --no-bin-links',
  cwd         => '/vagrant/src/jsx/',
  before      => Package['redis-server'],
  refreshonly => true,
}

## package: install redis-server
package {'redis-server':
  ensure => 'installed',
}