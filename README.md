# TFG REPO
On this repository I will upload the whole configuration to study a proof of concept of the tool Istio. For each feature tu analyze there will be 
an specfic tag therefore to try yourself each concept you will need to checkout to the corresponding tag
git checkout tag
Execute the terraform to create the infrastructure where Istio will be deployed
terraform apply
Once the infrastructure is created run bash init.sh and this will configure Istio. The configuration files of Istio will be store in ./istio_configuration
