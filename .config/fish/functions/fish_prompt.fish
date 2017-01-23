# Settings
set -g __prompt_min_duration 2
set -g __prompt_excludes git less

# Solarized
set -g __solarized_base03 "#002b36"
set -g __solarized_base02 "#073642"
set -g __solarized_base01 "#586e75"
set -g __solarized_base00 "#657b83"
set -g __solarized_base0 "#839496"
set -g __solarized_base1 "#93a1a1"
set -g __solarized_base2 "#eee8d5"
set -g __solarized_base3 "#fdf6e3"
set -g __solarized_yellow "#b58900"
set -g __solarized_orange "#cb4b16"
set -g __solarized_red "#dc322f"
set -g __solarized_magenta "#d33682"
set -g __solarized_violet "#6c71c4"
set -g __solarized_blue "#268bd2"
set -g __solarized_cyan "#2aa198"
set -g __solarized_green "#859900"

# my fish_prompt colors
set -g __prompt_color_duration $__solarized_cyan
set -g __prompt_color_return_decoration $__solarized_base01
set -g __prompt_color_user_delimiter $__solarized_base01
set -g __prompt_color_return_error $__solarized_red
set -g __prompt_color_return_success $__solarized_green
set -g __prompt_color_virtualenv $__solarized_magenta
set -g __prompt_color_cwd $__solarized_green
set -g __prompt_color_user $__solarized_blue
set -g __prompt_color_host $__solarized_blue
set -g __prompt_color_prompt_end $__solarized_blue

# __fish_git_prompt's colors

# Configure __fish_git_prompt
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream 1
set -g __fish_git_prompt_describe_style contains

set -g __fish_git_prompt_color_branch $__solarized_yellow
set -g __fish_git_prompt_color_branch_detached $__solarized_red
set -g __fish_git_prompt_color_merging $__solarized_yellow
set -g __fish_git_prompt_color_stagedstate $__solarized_green
set -g __fish_git_prompt_color_dirtystate $__solarized_red
set -g __fish_git_prompt_color_untrackedfiles $__solarized_yellow
set -g __fish_git_prompt_color_stashstate $__solarized_base0
set -g __fish_git_prompt_color_upstream $__solarized_blue
set -g __fish_git_prompt_color_cleanstate $__solarized_green

# set -g ___fish_git_prompt_char_dirtystate '±'
# set -g ___fish_git_prompt_char_untrackedfiles '?'
# set -g ___fish_git_prompt_char_stashstate '_'
# set -g ___fish_git_prompt_char_upstream_ahead '⇡'
# set -g ___fish_git_prompt_char_upstream_behind '⇣'
# set -g ___fish_git_prompt_char_upstream_diverged '⌥'
# set -g ___fish_git_prompt_char_upstream_equal ''


function fish_prompt --description 'Write out the prompt'
    set -g __prompt_last_ret $status
    set -g __prompt_last_duration $CMD_DURATION
    set -g __prompt_last_command $history[1]

    if not set -q status
        set -g __prompt_last_ret 0
    end

    # Configurable text
    set -g t_date_format '%m-%d %H:%M:%S%z'
    set -g t_user_delimiter "@"
    set -g t_return_surround \
        (concat (set_color $__prompt_color_return_decoration) "[" \
                (set_color normal)) \
        (concat (set_color $__prompt_color_return_decoration) "]" \
                (set_color normal))
    set -g t_prompt_end '➞ '
    set -g t_prompt_end '$ '

    # Private utility functions
    # - Functions that could be executed more than once in fish_prompt.
    # - Moke sure to delete all of these at the end of fish_prompt
    function surround_text_with --argument-names text before after
        if not set -q after
            set -l after $before
        end
        concat $before $text $after
    end

    function join_with_str --argument-names str
        set -l list
        if test (count $argv) -eq 1
            set list $argv[2]
        else
            set list $argv[2..-1]
        end

        set -l is_first 0

        for item in $list
            if test -n "$is_first"
                and test $is_first -eq 1  # "false"
                concat $str
            end

            concat $item

            if test -n "$is_first"
                and test $is_first -eq 0  # "true"
                set is_first 1  # "false"
            end
        end
    end

    function pad_str --argument-names str
        switch "$str"
            case ''
                concat " "
            case ' *'
                concat $str
            case '*'
                concat " " $str
        end
    end

    # Private functions
    function update_hostname
        if not set -q __fish_prompt_hostname
            set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
        end
    end

    function set_color_for_return_status --argument-names return_status
        set -l color $__prompt_color_return_success
        if test -n "$return_status"
            and test $return_status -gt 0
            set color $__prompt_color_return_error
        end
        set_color $color
    end

    function format_venv
        if set -q VIRTUAL_ENV
            string trim (concat \
                (set_color $__prompt_color_virtualenv) \
                "(" \
                (basename "$VIRTUAL_ENV") \
                ")" \
                (set_color normal))
        end
    end

    function format_return_status
        surround_text_with \
            (concat (set_color_for_return_status $__prompt_last_ret) $__prompt_last_ret \
                (set_color normal)) \
            $t_return_surround
    end

    function format_user
        join_with_str (set_color $__prompt_color_user_delimiter)$t_user_delimiter \
            (concat (set_color $__prompt_color_user) $USER) \
            (concat (set_color $__prompt_color_host) $__fish_prompt_hostname \
                (set_color normal))
    end

    function format_cwd
        concat (set_color $__prompt_color_cwd) (prompt_pwd) \
                (set_color normal)
    end

    function format_git
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

    function format_debug
        set -l filename (status -f)

        if not test "$filename" = "Standard input"
            concat \
                (set_color fff) $filename \
                (set_color 777) ":" \
                (set_color fff) (status -n) \
                (set_color normal)
        end
    end

    function format_prompt_end
        concat (set_color $__prompt_color_prompt_end) $t_prompt_end
    end

    function format_duration
        set -l excluded (__prompt_excluded $__prompt_last_command)
        if test -n "$__prompt_last_duration"
            and test -n "$__prompt_min_duration"
            and test $__prompt_last_duration -gt $__prompt_min_duration
            and test $excluded -ne 1
            set -l duration (__prompt_format_time $__prompt_last_duration)
            if test -n "$duration"
                concat \
                    (set_color $__prompt_color_duration) \
                    $duration \
                    (set_color normal)
            end
        end
    end

    # Assemble prompt
    update_hostname
    string join ' ' \
        (format_return_status) \
        (format_user) \
        (format_cwd) \
        (format_venv) \
        (format_git)

    printf (format_prompt_end)
    printf (set_color normal)

    # Remove private utility function
    functions -e surround_text_with
    functions -e join_with_str
    functions -e pad_str
    # Private functions
    functions -e format_user
    functions -e format_date
    functions -e format_duration
    functions -e get_hostname
    functions -e set_color_for_return_status
    functions -e format_venv
    functions -e format_return_status
    functions -e format_cwd
    functions -e set_text_branch
    functions -e format_git
    functions -e format_debug
    functions -e format_prompt_end
    # z --add "$PWD"
end


function __prompt_excluded -a cmd
  string match --quiet --regex "^($__prompt_excludes)\b" $cmd
end


function __prompt_format_time -a milliseconds
  set -l seconds (math "$milliseconds / 1000")
  set -l formatted (date --utc --date @$seconds "+%-kh %-Mm %-Ss")
  string replace --regex '^[0\D\s]+' '' $formatted
end
