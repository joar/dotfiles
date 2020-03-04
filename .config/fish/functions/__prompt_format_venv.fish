function __prompt_format_venv -d 'Format python VIRTUAL_ENV'
  if set -q VIRTUAL_ENV
    string join '' \
      (set_color $__prompt_color_virtualenv) \
      (printf '☤:%s' (basename $VIRTUAL_ENV)) \
      (set_color normal)
  end
end
