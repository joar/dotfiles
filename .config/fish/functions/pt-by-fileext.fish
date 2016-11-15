function pt-by-fileext --description 'Run \'pt\' with --file-search-regexp set to $fileext' --argument-names search fileext
  set -l pt_args $argv[3..-1]
  echo pt_args $pt_args

  if not test -z "$fileext"
    set pt_args $pt_args \
      --file-search-regexp='\.('(string join '|' (string split ',' $fileext))')$'
  end

  echo pt $pt_args $search
  pt $pt_args $search
end

