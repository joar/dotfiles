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
set -gx GOROOT /usr/lib/go
__fish_config_optional_path ~/go/go1.17/bin
# go install $cmd bins
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

# snap
__fish_config_optional_path /snap/bin

# JetBrains IDEs
__fish_config_optional_path ~/.local/share/JetBrains/Toolbox/scripts

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

set -gx NPM_PACKAGES "$HOME/.npm-packages"

# Use `--fancy` by default when running `pipenv shell`
set -x PIPENV_SHELL_FANCY "not null"

# Init virtualfish
# virtualfish is installed via
# $ pip --version
# pip 9.0.1 from /home/joar/.local/lib/python3.5/site-packages (python 3.5)
# $ pip install --user virtualfish
set --universal VIRTUAL_ENV_DISABLE_PROMPT "yes"

eval (direnv hook fish)

set -gx BAT_THEME "Solarized (light)"

# gcloud overrides
set -gx CLOUDSDK_PYTHON_SITEPACKAGES 1
set -gx CLOUDSDK_PYTHON /usr/bin/python
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/joar/google-cloud-sdk/path.fish.inc' ]; . '/home/joar/google-cloud-sdk/path.fish.inc'; end

# pyenv
status is-interactive; and pyenv init --path | source
pyenv init - | source

# pyenv-virtualenv
status --is-interactive; and pyenv virtualenv-init - | source

# https://wiki.archlinux.org/title/Git#Signing_commits
set -x GPG_TTY (tty)
