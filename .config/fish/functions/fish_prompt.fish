function fish_prompt --description 'Write out the prompt'
    set -g last_ret $status
    if not set -q status
        set -g last_ret 0
    end

    # Colors
    set -g c_date cyan
    set -g c_return_decoration brgrey
    set -g c_return_error brred
    set -g c_return_success brgreen
    set -g c_virtualenv magenta
    set -g c_cwd green
    set -g c_git brred
    set -g c_user blue
    set -g c_user_delimiter brgrey
    set -g c_host $c_user
    set -g c_prompt_end $c_user
    set -g c_docker 00ffde

    # Configurable text
    set -g t_date_format '%m-%d %H:%M:%S%z'
    set -g t_user_delimiter "@"
    set -g t_return_surround \
        (concat (set_color $c_return_decoration) "[" \
                (set_color normal)) \
        (concat (set_color $c_return_decoration) "]" \
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
            if not test "$is_first" -eq 0
                concat $str
            end

            concat $item

            if test "$is_first" -eq 0
                set is_first 1
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
        set -l color $c_return_success
        if test "$return_status" -gt 0
            set color $c_return_error
        end
        set_color $color
    end

    function get_text_venv
        if set -q VIRTUAL_ENV
            concat \
                (set_color $c_virtualenv) \
                "(" \
                (basename "$VIRTUAL_ENV") \
                ")" \
                (set_color normal)
        end
    end

    function get_text_return_status
        surround_text_with \
            (concat (set_color_for_return_status $last_ret) $last_ret \
                (set_color normal)) \
            $t_return_surround
    end

    function get_text_user
        join_with_str (set_color $c_user_delimiter)$t_user_delimiter \
            (concat (set_color $c_user) $USER) \
            (concat (set_color $c_host) $__fish_prompt_hostname \
                (set_color normal))
    end

    function get_text_cwd
        concat (set_color $c_cwd) (prompt_pwd) \
                (set_color normal)
    end

    function get_text_git
        set -l output (__fish_git_prompt ^ /dev/null)
        if not test "$output" = ""
            concat (set_color $c_git) $output \
                (set_color normal)
        end
    end

    function get_text_docker
        if not test "$DOCKER_MACHINE_NAME" = ""
            concat (set_color $c_docker) "(machine: $DOCKER_MACHINE_NAME)" \
                (set_color normal)
        end
    end

    function get_text_debug
        set -l filename (status -f)

        if not test "$filename" = "Standard input"
            concat \
                (set_color fff) $filename \
                (set_color 777) ":" \
                (set_color fff) (status -n) \
                (set_color normal)
        end
    end

    function get_text_prompt_end
        concat (set_color $c_prompt_end) $t_prompt_end
    end

    function get_text_date
        concat \
            (set_color $c_date) \
            (date +$t_date_format) \
            (set_color normal)
    end

    # Assemble prompt
    update_hostname

    printf "%s %s %s %s%s\n%s" \
        (get_text_return_status) \
        (get_text_date) \
        (get_text_user) \
        (get_text_cwd) \
        (pad_str (concat \
            (get_text_venv) \
            (get_text_git) \
            (pad_str (get_text_docker)) \
        )) \
        (get_text_prompt_end)

    printf (set_color normal)

    # Remove private utility function
    functions -e surround_text_with
    functions -e join_with_str
    functions -e pad_str
    # Private functions
    functions -e get_text_user
    functions -e get_text_date
    functions -e get_hostname
    functions -e set_color_for_return_status
    functions -e get_text_venv
    functions -e get_text_return_status
    functions -e get_text_cwd
    functions -e set_text_branch
    functions -e get_text_git
    functions -e get_text_docker
    functions -e get_text_debug
    functions -e get_text_prompt_end
    # z --add "$PWD"
end
