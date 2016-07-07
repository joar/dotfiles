set -gx GOPATH ~/gopath

# Go
set -gx PATH $GOPATH/bin $PATH

# Joar's local bin
set -gx PATH ~/local/bin $PATH
# XDG local bin
set -gx PATH ~/.local/bin $PATH

# rustup/cargo bin
set -gx PATH ~/.cargo/bin $PATH

#set -gx PATH ~/android-sdk-linux/tools ~/local/bin $PATH
set -gx PATH ~/pebble-dev/PebbleSDK-2.9/bin $PATH
set -gx PATH ~/apps/google-cloud-sdk/bin $PATH

# gcloud
# - The next line updates PATH for the Google Cloud SDK.
bass source '/home/joar/apps/google-cloud-sdk/path.bash.inc'

# - The next line enables shell command completion for gcloud.
bass source '/home/joar/apps/google-cloud-sdk/completion.bash.inc'

# Disable Python bytecode cache
# https://docs.python.org/2/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE
set -gx PYTHONDONTWRITEBYTECODE 1

# Source z.fish so that it builds the jump list from my directories
source $__fish_config_dir/functions/z.fish

# Run functions that have --on-variable PWD
auto_scratch_bin
auto_node_modules_bin

# Init virtualfish
# force python2
eval (/usr/bin/python -m virtualfish auto_activation global_requirements)
