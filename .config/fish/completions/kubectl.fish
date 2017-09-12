# Subcommand parsing


function __kctl_pos_args
    set -l pos_args (__fish_print_cmd_args_without_options)
    # echo __fish_print_cmd_args_without_options pos_args $pos_args > /dev/stderr
    # remove "kubectl"
    set -e pos_args[1]
    string join \n $pos_args
end

function __kctl_pos_argc
    set -l pos_args (__kctl_pos_args)
    set -l pos_argc (count $pos_args)
    # echo pos_argc $pos_argc pos_args $pos_args > /dev/stderr
    echo $pos_argc
end

function __kctl_get_subcommand_lines
    kubectl help | grep '^  '
end

function __kctl_parse_command
    set -l parts (string split --max 1 ' ' (string trim $argv))
    echo $parts[1]
    echo (string trim $parts[2])
end

function __kctl_get_subcommand_commands
    for line in (__kctl_get_subcommand_lines)
        set -l cmd (__kctl_parse_command $line)
        echo $cmd[1]
    end
end

function __kctl_get_resource_types
    kubectl get --help | grep '^  \* ' | awk '{ print $2 }'
end

# Constants

set __kctl_subcommands (__kctl_get_subcommand_commands)
set __kctl_resource_types (__kctl_get_resource_types)
set __kctl_expects_resource_type get edit delete describe explain annotate

# function __kctl_print_resource_types

function __kctl_using_command
    set -l cmd (commandline -opc)

    if test -n "$cmd"
        and test (count $cmd) -gt 1
        for arg in $argv
            # echo arg: $arg cmd: $cmd > /dev/stderr
            if contains -- $arg $cmd
                # echo contains $cmd > /dev/stderr
                true; return
            end
        end
    end

    false
end

function __kctl_needs_command
    set -l cmd (commandline -opc)
    set -e cmd[1]

    # echo cmd: $cmd

    for subcommand in $__kctl_subcommands
        # echo subcommand: $subcommand > /dev/stderr
        if contains -- $subcommand $cmd
            # echo no need command > /dev/stderr
            false; return
        end
    end
    true
end

function __kctl_needs_resource_type
    if __kctl_using_command $__kctl_expects_resource_type
    and test (__kctl_pos_argc) -eq 1
        true
    else
        false
    end
end

function __kctl_print_resources_auto
    set -l pos_args (__kctl_pos_args)

    # echo pos_args $pos_args > /dev/stderr
    set -l resource_type
    if __kctl_using_command $__kctl_expects_resource_type
        # echo pos_args $pos_args count (count $pos_args) > /dev/stderr
        set resource_type $pos_args[2]
    end

    # echo resource_type $resource_type > /dev/stderr

    __kctl_print_resources $resource_type
end

function __kctl_print_resources -a type
    kubectl get $type -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
end

function __kctl_get_pod_container_names -a pod
    kubectl get pods $pod \
        -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}'
end

function __kctl_print_context_names
    kubectl config view -o json | jq --raw-output '.contexts[] | .name'
end

# Commands
for line in (__kctl_get_subcommand_lines)
    set -l cmd (__kctl_parse_command $line)
    complete -c kubectl -n '__kctl_needs_command' -a $cmd[1] -d $cmd[2]
end

# --container
complete -c kubectl -n '__kctl_using_command exec' \
    -x -s c -l container \
    -d 'Container'

# --namespace
complete -c kubectl \
    -x -l namespace \
    -a '(__kctl_print_resources namespaces)' \
    -d 'Select namespace'

# --context
complete -c kubectl \
    -x -l context \
    -a '(__kctl_print_context_names)' \
    -d 'Select context'

# --help
complete -f -c kubectl \
    -s h -l help \
    -d 'Show help'

complete -f -c kubectl -n '__kctl_using_command exec logs port-forward' \
    -a '(__kctl_print_resources pod)' \
    -d 'Pod'

complete -f -c kubectl -n '__kctl_needs_resource_type' \
    -a (echo $__kctl_resource_types) \
    -d 'Resource type'

complete -f -c kubectl -n 'not __kctl_needs_resource_type; and __kctl_using_command $__kctl_expects_resource_type' \
    -a '(__kctl_print_resources_auto)'
