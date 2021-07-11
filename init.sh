#!/bin/bash
gcloud container clusters get-credentials projecto-demo-290916-gke --zone europe-west1-b --project projecto-demo-290916
kubectx gke_projecto-demo-290916_europe-west1-b_projecto-demo-290916-gke
istioctl install --set profile=demo -y
