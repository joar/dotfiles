set --universal fish_greeting ''

function __fish_config_optional_path \
        --argument-names path \
        --description 'Add a path to $PATH if it exists'
    if test -d $path
        set -gx fish_user_paths $path $fish_user_paths
    end
end

# rustup/cargo bin
__fish_config_optional_path ~/.cargo/bin

# golang
set -gx GOROOT ~/src/go
__fish_config_optional_path ~/src/go/bin

# default GOPATH
__fish_config_optional_path ~/go/bin

# Google Cloud SDK
__fish_config_optional_path ~/google-cloud-sdk/bin

# XDG local bin
# if status --is-login
#     set -gx PATH ~/.local/bin $PATH
# end
__fish_config_optional_path ~/.local/bin

# pyenv
__fish_config_optional_path ~/.pyenv/bin

# yarn
__fish_config_optional_path ~/.yarn/bin

# miniconda3
# __fish_config_optional_path ~/miniconda3/bin

# Turn off Python bytecode cache
# https://docs.python.org/2/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE
# Disabled due to performance concerns
# Enabled due to lack of concern
set -gx PYTHONDONTWRITEBYTECODE 1

# Mosh default escape
set -gx MOSH_ESCAPE_KEY \028  # Ctrl-X

# Set TERM and COLORTERM properly
#set -gx TERM xterm-256color
set -gx COLORTERM truecolor

# Run functions that have --on-variable PWD
auto_scratch_bin
auto_kube_config

set -gx NPM_PACKAGES "$HOME/.npm-packages"

# Use `--fancy` by default when running `pipenv shell`
set -x PIPENV_SHELL_FANCY "not null"

# Init virtualfish
# virtualfish is installed via
# $ pip --version
# pip 9.0.1 from /home/joar/.local/lib/python3.5/site-packages (python 3.5)
# $ pip install --user virtualfish

eval (/usr/bin/python3.6 -m virtualfish auto_activation global_requirements)

eval (direnv hook fish)

# pyenv - XXX: These smims are bad and they should feel bad
# status --is-interactive; and . (pyenv init -|psub)
# status --is-interactive; and . (pyenv virtualenv-init -|psub)

set -gx BAT_THEME "Solarized (light)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/joar/google-cloud-sdk/path.fish.inc' ]; . '/home/joar/google-cloud-sdk/path.fish.inc'; end
