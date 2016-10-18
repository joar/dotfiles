set -e fish_greeting

function __fish_config_optional_path \
        --argument-names path \
        --description 'Add a path to $PATH if it exists'
    if test -d $path
        set -gx PATH $path $PATH
    end
end

# rustup/cargo bin
__fish_config_optional_path ~/.cargo/bin

# fzf
__fish_config_optional_path ~/.fzf/bin

set -x __fish_config_dir (dirname (status -f))
set -l __local_config $__fish_config_dir/config.local.fish

test -f $__local_config; and . $__local_config
