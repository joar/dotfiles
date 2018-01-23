if not set -q __prompt_color_duration
  # load fish_prompt's variables if they aren't set
  fish_prompt > /dev/null
end

function fish_right_prompt
  string join ' ' \
    (__prompt_format_gcloud_project) \
    (__prompt_format_kube_config_context)
end
