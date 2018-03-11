if not set -q __prompt_color_duration
  # load fish_prompt's variables if they aren't set
  source ~/.config/fish/functions/fish_prompt.fish > /dev/null
end

function fish_right_prompt
  string join ' ' \
    "$__prompt_cache_kube_config_context"
end
