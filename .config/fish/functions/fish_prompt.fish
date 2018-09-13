# Settings
set -g __prompt_min_duration 2
set -g __prompt_excludes git less

# Solarized
set __solarized_base03 "#002b36"
set __solarized_base02 "#073642"
set __solarized_base01 "#586e75"
set __solarized_base00 "#657b83"
set __solarized_base0 "#839496"
set __solarized_base1 "#93a1a1"
set __solarized_base2 "#eee8d5"
set __solarized_base3 "#fdf6e3"
set __solarized_yellow "#b58900"
set __solarized_orange "#cb4b16"
set __solarized_red "#dc322f"
set __solarized_magenta "#d33682"
set __solarized_violet "#6c71c4"
set __solarized_blue "#268bd2"
set __solarized_cyan "#2aa198"
set __solarized_green "#859900"

# my fish_prompt colors
set __prompt_color_duration $__solarized_cyan
set __prompt_color_return_decoration $__solarized_base01
set __prompt_color_user_delimiter $__solarized_base01
set __prompt_color_return_error $__solarized_red
set __prompt_color_return_success $__solarized_green
set __prompt_color_virtualenv $__solarized_magenta
set __prompt_color_cwd $__solarized_green
set __prompt_color_user $__solarized_blue
set __prompt_color_host $__solarized_blue
set __prompt_color_prompt_end $__solarized_blue
set __prompt_color_kube_context $__solarized_violet
set __prompt_color_gcloud_project $__solarized_blue


# Configure __fish_git_prompt
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream 1
set -g __fish_git_prompt_describe_style contains

# __fish_git_prompt's colors
set -g __fish_git_prompt_color_branch $__solarized_yellow
set -g __fish_git_prompt_color_branch_detached $__solarized_red
set -g __fish_git_prompt_color_merging $__solarized_yellow
set -g __fish_git_prompt_color_stagedstate $__solarized_green
set -g __fish_git_prompt_color_dirtystate $__solarized_red
set -g __fish_git_prompt_color_untrackedfiles $__solarized_yellow
set -g __fish_git_prompt_color_stashstate $__solarized_base0
set -g __fish_git_prompt_color_upstream $__solarized_blue
set -g __fish_git_prompt_color_cleanstate $__solarized_green

function fish_prompt --description 'Write out the prompt'
  set -g __prompt_last_ret $status
  set -g __prompt_last_duration $CMD_DURATION
  set -g __prompt_last_command $history[1]

  if not set -q status
    set -g __prompt_last_ret 0
  end

  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  # Configurable text
  set -g __prompt_t_user_delimiter "@"
  set -g __prompt_t_return_surround \
    (string join '' \
      (set_color $__prompt_color_return_decoration) "[" \
      (set_color normal)) \
    (string join '' \
      (set_color $__prompt_color_return_decoration) "]" \
      (set_color normal))
  set -g __prompt_t_prompt_end '$ '

  # Assemble prompt
  string join ' ' \
    (__prompt_format_return_status) \
    (__prompt_format_duration) \
    (__prompt_format_user) \
    (__prompt_format_cwd) \
    (__prompt_format_git)

  printf (__prompt_format_prompt_end)
  printf (set_color normal)

end

function __prompt_status_color --argument-names return_status
  set -l color $__prompt_color_return_success
  if test -n "$return_status"
    and test $return_status -gt 0
    set color $__prompt_color_return_error
  end
  set_color $color
end

function __prompt_format_return_status
  surround_text_with \
    (concat (__prompt_status_color $__prompt_last_ret) $__prompt_last_ret \
      (set_color normal)) \
    $__prompt_t_return_surround
end

function __prompt_format_user
  string join (set_color $__prompt_color_user_delimiter)$__prompt_t_user_delimiter \
    (concat (set_color $__prompt_color_user) $USER) \
    (concat (set_color $__prompt_color_host) $__fish_prompt_hostname \
      (set_color normal))
end

function __prompt_format_cwd
  concat (set_color $__prompt_color_cwd) (prompt_pwd) \
      (set_color normal)
end

function __prompt_format_git
  set -l output (string replace --all --regex \
    '^\s|[()]' \
    '' \
    (__fish_git_prompt))

  set -l output (__fish_git_prompt)
  if test -n "$output"
    string trim (concat \
        (set_color $__prompt_color_git) \
        $output \
        (set_color normal))
  end
end

function __prompt_format_debug
  set -l filename (status -f)

  if not test "$filename" = "Standard input"
    string join '' \
      (set_color fff) $filename \
      (set_color 777) ":" \
      (set_color fff) (status -n) \
      (set_color normal)
  end
end

function __prompt_format_prompt_end
  string join '' (set_color $__prompt_color_prompt_end) $__prompt_t_prompt_end
end

function __prompt_format_duration
  set -l excluded $status

  if test -n "$__prompt_last_duration"
      and test -n "$__prompt_min_duration"
      and test $__prompt_last_duration -gt $__prompt_min_duration
      and not __prompt_excluded $__prompt_last_command
    set -l duration (__prompt_format_time $__prompt_last_duration)
    if test -n "$duration"
      string join '' \
        (set_color $__prompt_color_duration) \
        $duration \
        (set_color normal)
    end
  end
end

function __prompt_excluded -a cmd
  string match --quiet --regex "^($__prompt_excludes)\b" $cmd
end

function __prompt_format_time -a milliseconds
  set -l seconds (math "$milliseconds / 1000")
  set -l formatted (date --utc --date @$seconds "+%-kh %-Mm %-Ss")
  string replace --regex '^[0\D\s]+' '' $formatted
end

function __prompt_format_kube_config_context
  # if set -q KUBECONFIG;
  printf "%s%s%s" \
    (set_color $__prompt_color_kube_context) \
    "k8s:"(kubectl config current-context) \
    (set_color normal)
  # end
end

function __prompt_format_gcloud_project
  set -l current_project \
    (env PYTHONDONTWRITEBYTECODE= gcloud config get-value project ^ /dev/null)
  if test -n "$current_project"
    printf "%s%s%s" \
      (set_color $__prompt_color_gcloud_project) \
      "gcloud:$current_project" \
      (set_color normal)
  end
end
