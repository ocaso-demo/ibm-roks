#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# eval "$(jq -r '@sh "KUBECONFIG=\(.kubeconfig)"')"

route=$(oc get route -n openshift-gitops openshift-gitops-cntk-server -o json --kubeconfig=${KUBECONFIG} | jq -r '.spec.host')
password=$(oc get secret/openshift-gitops-cntk-cluster -n openshift-gitops -o json --kubeconfig=${KUBECONFIG} | jq -r '.data."admin.password"')

jq -n --arg route "$route" --arg password "$password" '{"route":$route, "password":$password}'