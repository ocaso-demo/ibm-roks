#!/bin/bash

# LOGGING Variables
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GREEN='\033[0;32m'
NRM='\033[0m'

log() {
    # inputs:
    # $1 Log Level [DEBUG,INFO,ERROR,WARN,FATAL]
    # $2 Message string
    case $1 in 
      DEBUG )
        printf "${WHITE}[DEBUG] $2 ${NRM}\n"
        ;;
      INFO )
        printf "${GREEN}[INFO] $2 ${NRM}\n"
        ;;
      ERROR )
        printf "${RED}[ERROR] $2 ${NRM}\n"
        ;;
      WARN )
        printf "${CYAN}[WARN] $2 ${NRM}\n"
        ;;
      FATAL)
        printf "${RED}[FATAL] $2 ${NRM}\n"
        ;;
      * )
        printf "${GREEN}[INFO] $2 ${NRM}\n"
        ;;
    esac
}

# export HOME="/root"
log "DEBUG" "HOME: $HOME"
log "INFO" "Install Tekton into the cluster"
log "DEBUG" "oc apply -f 2-services/operators/openshift-pipelines/operator.yaml -n openshift-operators"
oc apply -f 2-services/operators/openshift-pipelines/operator.yaml -n openshift-operators

sleep 180


log "INFO" "Wait for the Tekton installation to complete"
log "DEBUG" "oc wait --for condition=available --timeout 60s deployment.apps/openshift-pipelines-operator -n openshift-operators"
oc wait --for condition=available --timeout 60s deployment.apps/openshift-pipelines-operator -n openshift-operators



log "INFO" "Install ArgoCD into the cluster"
log "DEBUG" "oc apply -f 2-services/operators/openshift-gitops/operator.yaml -n openshift-operators"
oc apply -f 2-services/operators/openshift-gitops/operator.yaml -n openshift-operators

sleep 180


log "INFO" "Wait for the ArgoCD installation to complete"
log "DEBUG" "oc wait --for condition=available --timeout 60s deployment.apps/gitops-operator -n openshift-operators"
oc wait --for condition=available --timeout 60s deployment.apps/gitops-operator -n openshift-operators

sleep 180

log "INFO" "Complete"
exit 0
