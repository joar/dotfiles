function __fish_title_format_pwd --argument method
	if test "$method" = "basename_first"
		string join " ∈ " (basename (pwd)) (dirname (__fish_title_pwd))
		return
	end
	__fish_title_pwd
end

function __fish_title_replace_home --argument a_path
	string replace --regex '^'"$HOME" '~' "$a_path"
end

function __fish_title_pwd
	__fish_title_replace_home (pwd)
end

function fish_title --argument command
	set -l pwd (pwd)
	set -l title (string join "•" $command (__fish_title_format_pwd normal))
	if test -z "$command"
		__fish_title_format_pwd basename_first
		return
	end

	if test (string length "$title") -gt 30
		set title (string join "•" $command (__fish_title_format_pwd basename_first))
	end
	echo "$title"
end
