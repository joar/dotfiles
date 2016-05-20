set -e fish_greeting

set -x __fish_config_dir (dirname (status -f))
set -l local_config $__fish_config_dir/config.local.fish

test -f $local_config; and source $local_config
