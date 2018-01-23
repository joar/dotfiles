# vim: set sw=4:ts=4:sts=4:
function auto_kube_config --on-variable PWD --on-event kubectl:run --description 'Auomatically set $KUBECONFIG'
    set -l default_kube_config $HOME/.kube/config
    set -l kube_config_filename '.kube-config'
    set -l kube_config_search_path (pwd)
    set -l kube_configs

    set -l kube_config_dirs (findup $kube_config_search_path $kube_config_filename)
    for kube_config_dir in $kube_config_dirs
        set kube_configs "$kube_config_dir/$kube_config_filename" $kube_configs
    end

    set -e -g -x KUBECONFIG

    if count $kube_configs > /dev/null
      set -g -x KUBECONFIG (string join ':' $kube_configs[-1..1]):$default_kube_config
    end
end
