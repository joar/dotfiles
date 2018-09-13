function auto_scratch_bin --on-variable PWD
    status --is-command-substitution; and return
    set -l git_root (pwd)"/"(git rev-parse --show-cdup ^ /dev/null)

    if test ! "$status" -eq 0
        __remove_scratch_bin_path
        return
    end

    set -l bin_path $git_root".scratch/bin"

    if not test -d "$bin_path"
        return
    end

    set -gx __scratch_bin_path $bin_path
    set -gx PATH $__scratch_bin_path $PATH
end

# Private function, used to clean up $PATH
function __remove_scratch_bin_path
    if contains $__scratch_bin_path $PATH
        set -l restored_PATH

        for path in $PATH
            if not test "$path" = "$__scratch_bin_path"
                set restored_PATH $restored_PATH $path
            end
        end

        set -gx PATH $restored_PATH
    end
end
