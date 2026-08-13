jwtd() {
  echo $1 | jq -R 'split(".") | .[1] | @base64d | fromjson'
}