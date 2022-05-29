source $HOME/.sh/comp/_kube_contexts.sh
source $HOME/.sh/comp/_kube_namespaces.sh

kubelogs() {
  kubectl logs "$1" -f | grep "^{" | jq
}

kubewarns() {
  kubectl logs "$1" -f | grep "^{" | jq '. | select(.Level=="Warning")'
}
