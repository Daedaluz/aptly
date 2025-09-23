#!/bin/bash
#helm install --create-namespace --namespace aptly aptly ./helm/aptly -f ./values.yml
helm upgrade --install --create-namespace --namespace aptly aptly ./helm/aptly -f ./values.yml
