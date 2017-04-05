function fish_title --argument command
	string join " - " $command (pwd)
end
