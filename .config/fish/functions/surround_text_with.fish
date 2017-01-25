function surround_text_with --argument-names text before after
  if not set -q after
    set -l after $before
  end
  string join '' $before $text $after
end
