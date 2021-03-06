### Note: the prefix 'compiler::', corresponds to a puppet convention:
###
###       https://github.com/jeff1evesque/machine-learning/issues/2349
###
class compiler::start_browserify {
    # variables
    $hiera_general   = hiera('general')
    $root_dir        = $hiera_general['root']
    $environment     = $hiera_general['environment']
    $dev_env_path    = "${root_dir}/puppet/environment/${environment}"

    # manually compile
    exec { 'browserify':
        command  => "./browserify ${root_dir}",
        cwd      => "${dev_env_path}/modules/compiler/scripts",
        path     => '/usr/bin',
        provider => shell,
    }
}