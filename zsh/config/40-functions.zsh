code() {
  if (( $# == 0 )); then
    cursor .
  else
    cursor "$@"
  fi
}