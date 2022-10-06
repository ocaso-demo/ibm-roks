#!/usr/bin/env bash

set -eo pipefail

[[ -n "${DEBUG:-}" ]] && set -x

set +e
OC_VERISON=`oc version --client | grep -E '4.[7-9].[0-9]|4.[1-9][0-9].[0-9]|4.[1-9][0-9][0-9].[0-9]'`

GIT_GITOPS_NAMESPACE=${GIT_GITOPS_NAMESPACE:-openshift-gitops}


install_argocd () {
    echo "Installing OpenShift GitOps Operator for OpenShift version ${OC_VERISON}"
    oc create ns ${GIT_GITOPS_NAMESPACE} || true
    oc apply -f ./setup/ocp4x/
    while ! oc wait crd applications.argoproj.io --timeout=-1s --for=condition=Established  2>/dev/null; do sleep 30; done
    sleep 60
    while ! oc wait pod --timeout=30s --for=condition=Ready --all -n ${GIT_GITOPS_NAMESPACE} > /dev/null; do sleep 30; done
}

create_custom_argocd_instance () {
    echo "Create a custom ArgoCD instance with custom checks"

    oc apply -f ./setup/ocp4x/argocd-instance/ -n ${GIT_GITOPS_NAMESPACE}
    while ! oc wait pod --timeout=-1s --for=condition=ContainersReady -l app.kubernetes.io/name=${GIT_GITOPS_NAMESPACE}-cntk-server -n ${GIT_GITOPS_NAMESPACE} > /dev/null; do sleep 30; done
}

patch_argocd_tls () {
    echo "Patch ArgoCD instance with TLS certificate"

    INGRESS_SECRET_NAME=$(oc get ingresscontroller.operator default \
    --namespace openshift-ingress-operator \
    -o jsonpath='{.spec.defaultCertificate.name}')

    if [[ -z "${INGRESS_SECRET_NAME}" ]]; then
        echo "Cluster is using a self-signed certificate."
        popd
        return 0
    fi

    oc extract secret/${INGRESS_SECRET_NAME} -n openshift-ingress
    oc create secret tls -n ${GIT_GITOPS_NAMESPACE} ${GIT_GITOPS_NAMESPACE}-cntk-tls --cert=tls.crt --key=tls.key --dry-run=client -o yaml | oc apply -f -
    oc -n ${GIT_GITOPS_NAMESPACE} patch argocd/${GIT_GITOPS_NAMESPACE}-cntk --type=merge \
    -p='{"spec":{"tls":{"ca":{"secretName":"${GIT_GITOPS_NAMESPACE}-cntk-tls"}}}}'

    rm tls.key tls.crt
}

print_urls_passwords () {

    echo "# Openshift Console UI: $(oc whoami --show-console)"
    echo "# "
    echo "# Openshift ArgoCD/GitOps UI: $(oc get route -n ${GIT_GITOPS_NAMESPACE} ${GIT_GITOPS_NAMESPACE}-cntk-server -o template --template='https://{{.spec.host}}')"
    echo "# "
    echo "# To get the ArgoCD/GitOps URL and admin password:"
    echo "# -----"
    echo "oc get route -n ${GIT_GITOPS_NAMESPACE} ${GIT_GITOPS_NAMESPACE}-cntk-server -o template --template='https://{{.spec.host}}'"
    echo "oc extract secrets/${GIT_GITOPS_NAMESPACE}-cntk-cluster --keys=admin.password -n ${GIT_GITOPS_NAMESPACE} --to=-"
    echo "# -----"
}


# main


install_argocd

create_custom_argocd_instance

patch_argocd_tls

print_urls_passwords

exit 0
