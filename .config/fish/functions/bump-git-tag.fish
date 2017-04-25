function bump-git-tag \
    --description 'Bump the git-tagged version' \
    --argument-names semver_increment semver_preid current_version
    set -l versions (semver (git tag))
    set -l autobumped_version
    set -l right_prompt

    if test -z "$current_version"
        and test -n "$versions"
        set current_version $versions[-1]
    end

    if test -n "$versions"
        if test -z "$semver_increment"
            set semver_increment 'prerelease'
        end

        set -l semver_args --increment $semver_increment

        if test -n "$semver_preid"
            set semver_args $semver_args --preid $semver_preid
        end

        set autobumped_version (semver $semver_args $current_version)
        set right_prompt (set_color blue; echo autobumped from version: $current_version; set_color normal)
    end

    read --local --command "$autobumped_version" --prompt 'set_color green; printf "new tag"; set_color normal; echo "> "' --right-prompt "echo '$right_prompt'" tag_name

    git tag -a $tag_name -m $tag_name
end
