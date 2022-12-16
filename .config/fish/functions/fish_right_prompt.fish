source ~/.config/fish/functions/fish_prompt.fish

function __prompt_hide_sensitive
  if test -z "$PROMPT_HIDE_SENSITIVE"
    for line in $argv
      echo "$line"
    end
  end
end

function fish_right_prompt
  string join ' ' \
    (__prompt_format_venv) #\
    # kubectl has become slow
    # (__prompt_hide_sensitive (__prompt_format_kube_config_context)) # \
    # (__prompt_format_gcloud_project)
end
