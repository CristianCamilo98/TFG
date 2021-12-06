#!/bin/bash
istioctl verify-install

for i in $(seq 1 3);do
    kubectl apply -f istio-1.10.2/samples/addons/
    if [ $? -eq 0 ]
    then
        break
    fi
done


## Lets start deploying our application, we have downloaded the repository https://github.com/istioinaction/book-source-code
## First of all we will create a namespace in which we'll deployy our samples
kubens istioinaction
## With istio you can do either activate that automatically every pode in a certain workspace to have istio-proxy inside or in the yaml file of
## the deployment have added de configuration... lets explain this with commands.
## With the following command we will take a kubernetes resource file and enrich it with a sidecar deployment of the Istio service proxy, this will 
## modify the file to have configured the proxy so when you apply that file istio will be deployed too.
#istioctl kube-inject -f book-source-code/services/catalog/kubernetes/catalog.yaml
## Or you can activate that automatically in a certain workspace Istio will automatically inject the sidecar proxy 

#Make pod return error
#istio_examples/chaos.sh 500 50
#istio_examples/chaos.sh 500 delete

# In order to deplay the dashboards of the addons run:
# istioctl dashboard (jaeger|grafana|kiali|prometheus)
# Installing Flagger into the cluster
helm repo add flagger https://flagger.app
kubectl apply -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml
helm install flagger flagger/flagger --namespace=istio-system --set crd.create=false --set meshProvider=istio --set metricsServer=http://prometheus:9090
