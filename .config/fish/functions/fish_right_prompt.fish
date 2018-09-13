source ~/.config/fish/functions/fish_prompt.fish

function fish_right_prompt
  string join ' ' \
    (__prompt_format_venv) \
    (__prompt_format_kube_config_context) # \
    # (__prompt_format_gcloud_project)
end
