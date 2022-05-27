kubelogs() {
  kubectl logs "$1" -f | grep "^{" | jq
}

kubewarns() {
  kubectl logs "$1" -f | grep "^{" | jq '. | select(.Level=="Warning")'
}
