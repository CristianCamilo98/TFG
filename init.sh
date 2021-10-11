#!/bin/bash
istioctl verify-install
kubectl apply -f istio-1.10.2/samples/addons/

## Lets start deploying our application, we have downloaded the repository https://github.com/istioinaction/book-source-code
## First of all we will create a namespace in which we'll deployy our samples
kubens istioinaction
## With istio you can do either activate that automatically every pode in a certain workspace to have istio-proxy inside or in the yaml file of
## the deployment have added de configuration... lets explain this with commands.
## With the following command we will take a kubernetes resource file and enrich it with a sidecar deployment of the Istio service proxy, this will 
## modify the file to have configured the proxy so when you apply that file istio will be deployed too.
#istioctl kube-inject -f book-source-code/services/catalog/kubernetes/catalog.yaml
## Or you can activate that automatically in a certain workspace Istio will automatically inject the sidecar proxy 

##
kubectl apply -f istio_examples/ingress-gateway.yaml

#Make pod return error
