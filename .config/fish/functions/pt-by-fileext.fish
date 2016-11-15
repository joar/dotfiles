function pt-by-fileext --description 'Run \'pt\' with --file-search-regexp set to $fileext' --argument-names search fileext
  set -l pt_args

  if test (count $argv) -gt 2
    set pt_args $argv
  end

  if not test -z "$fileext"
    set pt_args $pt_args \
      --file-search-regexp='\.('(string join '|' (string split ',' $fileext))')$'
  end

  pt $pt_args $search
end

