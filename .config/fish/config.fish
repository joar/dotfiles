set -e fish_greeting

set -x __fish_config_dir (dirname (status -f))
set -l __local_config $__fish_config_dir/config.local.fish

test -f $__local_config; and . $__local_config
