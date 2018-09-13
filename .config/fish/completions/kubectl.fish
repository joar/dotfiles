# Extract argument values and options
################################################################################

function __kctl_extract_options_section \
--description 'Extract the `Options:` section from `kubectl --help` output'

    sed -n -E -f ~/.config/fish/completions/kubectl-extract-options.sed
end

function __kctl_extract_subcommand_lines \
--description 'Get lines with kubectl commands and their description'
    kubectl help $argv | grep -E '^  [a-z-]+\s+[A-Z]'
end

function __kctl_extract_command_info \
--description 'Parses a command and description from a `kubectl help` line'
    set -l parts (string split --max 1 ' ' (string trim $argv))
    echo $parts[1]
    echo (string trim $parts[2])
end

function __kctl_extract_commands_as_arguments \
--description 'Format a command for use in complete\'s --argument'
    for line in (__kctl_extract_subcommand_lines $argv)
        set -l info (__kctl_extract_command_info $line)
        printf '%s\t%s\n' $info
    end
end

function __kctl_extract_subcommand_values
    for line in (__kctl_extract_subcommand_lines)
        set -l cmd (__kctl_extract_command_info $line)
        echo $cmd[1]
    end
end

function __kctl_extract_resource_types
    kubectl get --help | grep '^  \* ' | awk '{ print $2 }'
end

function __kctl_parse_resource_list_as_arguments -a type
    # Format a resource arguments based on the resource JSON
    jq --raw-output -f ~/.config/fish/completions/kubectl-parse-resource-list-as-arguments.jq
    or status stack-trace
end

function __kctl_print_resources -a type
    kubectl get $type -o json \
        | __kctl_parse_resource_list_as_arguments
    # kubectl get $type -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.labels}{"\n"}{end}'
end

function __kctl_get_pod_container_names -a pod
    kubectl get pods $pod -o json \
        | jq --raw-output '.spec.containers[] | .name'
    or status stack-trace
end

function __kctl_extract_contexts_as_arguments
    kubectl config view -o json \
        | jq --raw-output '.contexts[] | @text "\(.name)\t\(.context.cluster)"'
    or status stack-trace
end

function __kctl_extract_clusters_as_arguments \
--description 'Format a list of possible cluster argument based on th kubectl config'
    kubectl config view -o json \
        | jq --raw-output '.clusters[] | .name'
    or status stack-trace
end

# Commandline introspection
################################################################################

function __kctl_print_resources_auto
    set -l pos_args (__kctl_pos_args)

    set -l resource_type
    if __kctl_using_command_any $__kctl_expects_resource_type
        set resource_type $pos_args[2]
    end

    # echo resource_type $resource_type > /dev/stderr
    __kctl_print_resources $resource_type
end

function __kctl_using_command_any \
--description 'Check if current command is any of $argv'
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

set __kctl_const_context_regex '--context\s*(\s|=)\s*([^\s])'
set __kctl_const_namespace_regex '--namespace\s*(\s|=)\s*([^\s])'

function __kctl_current_pos_args \
--description 'Get the current subcommand'
    set -l parts (string replace --regex -- \
        $__kctl_const_context_regex '' \
        (commandline -opc))
    set parts (string replace --regex -- $__kctl_const_namespace_regex '' \
        "$parts")

    if test (count $parts) -gt 1
        for part in $parts[2..-1]
            echo $part
        end
    end
end

function __kctl_current_context \
--description 'Get the current --context if any'
    string replace --regex -- \
        $__kctl_const_context_regex '\2' (commandline -opc)
end


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

function __kctl_needs_root_command \
--description 'Check if no current command is given'
    set -l cmd (commandline -opc)
    set -e cmd[1]

    for subcommand in $__kctl_root_command_values
        # echo subcommand: $subcommand > /dev/stderr
        if contains -- $subcommand $cmd
            # echo no need command > /dev/stderr
            false; return
        end
    end
    true
end

function __kctl_needs_resource_type \
--description 'Check if current command needs a resources type argument'
    if __kctl_using_command_any $__kctl_expects_resource_type
    and test (__kctl_pos_argc) -eq 1
        true
    else
        false
    end
end

# Constants
################################################################################

set __kctl_root_command_values (__kctl_extract_subcommand_values)
set __kctl_resource_types (__kctl_extract_resource_types)
set __kctl_expects_resource_type get edit delete describe explain annotate

# Completions
################################################################################

# Commands
# for line in (__kctl_extract_subcommand_lines)
#     set -l cmd (__kctl_extract_command_info $line)
#     complete -c kubectl -n '__kctl_needs_root_command' -a $cmd[1] -d $cmd[2]
# end

complete -c kubectl \
    --condition '__kctl_needs_root_command' \
    --no-files \
    --arguments '(__kctl_extract_commands_as_arguments)'

# --namespace/-n
complete -c kubectl \
    -x -s n -l namespace \
    -a '(__kctl_print_resources namespaces)' \
    -d 'Select namespace'

complete -c kubectl \
    --condition '__kctl_using_command_any get describe' \
    --long-option all-namespaces

# --context
complete -c kubectl \
    -x -l context \
    -a '(__kctl_extract_contexts_as_arguments)' \
    -d 'Select context'

# --help
complete -f -c kubectl \
    --short-option h --long-option help \
    --description 'Show help'

# # ( exec | logs ) ( POD ) -c/--container $CONTAINER
# complete -c kubectl \
#     --condition '__kctl_using_command_any exec logs' \
#     --short-option c --long-option container \
#     --arguments '(__kctl_fmt_args_container)' \
#     --description 'Container'

# ( logs ) -f/--follow
complete -c kubectl \
    --condition '__kctl_using_command_any logs' \
    --short-option f --long-option follow \
    --description 'Follow logs'

# ( exec | logs | port-forward ) $POD
complete -c kubectl \
    --condition '__kctl_using_command_any exec logs port-forward' \
    --arguments '(__kctl_print_resources pod)' \
    --no-files \
    --description 'Pod'

complete -f -c kubectl -n '__kctl_needs_resource_type' \
    -a (echo $__kctl_resource_types) \
    --description 'Resource type'

complete -c kubectl \
    --condition 'not __kctl_needs_resource_type; and __kctl_using_command_any $__kctl_expects_resource_type' \
    --no-files \
    --arguments '(__kctl_print_resources_auto)'

# ( apply | replace | create | delete ) -f $FILE
complete -c kubectl \
    --condition '__kctl_using_command_any create apply replace delete' \
    --short-option f --long-option file \
    --require-parameter

# config
# ------------------------------------------------------------------------------
complete -c kubectl \
    --condition '__kctl_using_command_any config; and test (__kctl_pos_argc) -eq 1' \
    --no-files \
    --arguments '(__kctl_extract_commands_as_arguments config)'

# config ( set-context | use-context | delete-context )
complete -c kubectl \
    --condition '__kctl_using_command_any config;
        and __kctl_using_command_any use-context set-context delete-context' \
    --no-files \
    --arguments '(__kctl_extract_contexts_as_arguments)'

# config ( delete-cluster )
complete -c kubectl \
    --condition '__kctl_using_command_any config;
        and __kctl_using_command_any delete-cluster' \
    --no-files \
    --arguments '(__kctl_extract_clusters_as_arguments)'

# set
complete -c kubectl \
    --condition '__kctl_using_command_any set' \
    --no-files \
    --arguments '(__kctl_extract_commands_as_arguments set)'
