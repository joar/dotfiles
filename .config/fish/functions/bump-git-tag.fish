function bump-git-tag \
    --description 'Helper to create a new git tag for a new version' \
    --argument-names semver_increment semver_preid
    set -l current_version (semver (git tag))
    set -l autobumped_version
    set -l right_prompt

    if test -n "$current_version"
        if test -z "$semver_increment"
            set semver_increment 'prerelease'
        end

        set -l semver_input $current_version

        if test "$semver_increment" = 'prerelease'
            and not echo $semver_input | sed '/-./q 0; q 1'
            # avoid bumping patch when creating a new prerelease
            set semver_input $semver_input'-fake'
        end

        set -l semver_args --increment $semver_increment

        if test -n "$semver_preid"
            set semver_args $semver_args --preid $semver_preid
        end

        set autobumped_version (semver $semver_args $semver_input)
        set right_prompt (set_color blue; echo autobumped from version: $current_version; set_color normal)
    end

    read --local --command "$autobumped_version" --prompt 'set_color green; printf "new tag"; set_color normal; echo "> "' --right-prompt "echo '$right_prompt'" tag_name

    git tag -a $tag_name -m $tag_name
end
