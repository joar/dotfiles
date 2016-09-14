set -e fish_greeting

# rustup/cargo bin
if test -d ~/.cargo/bin
    set -gx PATH ~/.cargo/bin $PATH
end

set -x __fish_config_dir (dirname (status -f))
set -l __local_config $__fish_config_dir/config.local.fish

test -f $__local_config; and . $__local_config
