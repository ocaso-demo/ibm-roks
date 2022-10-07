#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

ibmcloud login --apikey ${IBM_APIKEY} -r eu-de -q || exit 1

ibmcloud plugin install container-service -f

ibmcloud ks cluster config --admin -c ${CLUSTER_NAME} -q || exit 1

# ibmcloud ks cluster config --admin -c ${CLUSTER_NAME} --output yaml > kubeconfig.yaml || exit 1