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

# XDG local bin
__fish_config_optional_path ~/.local/bin

# Disable Python bytecode cache
# https://docs.python.org/2/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE
set -gx PYTHONDONTWRITEBYTECODE 1

# Run functions that have --on-variable PWD
auto_scratch_bin
auto_node_modules_bin

# Init virtualfish
# force python2
eval (/usr/bin/python -m virtualfish auto_activation global_requirements)
