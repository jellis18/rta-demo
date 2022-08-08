# Demo Application

This repo corresponds to a [talk](https://docs.google.com/presentation/d/1X_76P1CdcFJa6FAw3BZPIr3BGSAAbhMb-RTbh30kZic/edit?usp=sharing) given at a [RTA Meetup](https://www.rtpanalysts.org/)

The goal is to give a glimpse into several devops related tools including Docker, Terraform and Kubernetes through a simple demo.

In this demo we have a simple web application that performs Named Entity Recognition on user supplied text and displays the results. We then:
* create an [AKS cluster](https://azure.microsoft.com/en-us/services/kubernetes-service/) and an [ACR](https://azure.microsoft.com/en-us/services/container-registry/) using terraform. 
* build an image of our web application using Docker
* tag and push that image to ACR
* Deploy the web application using a kubernetes Deployment and Service

The relevant commands for each tool are below

## Terraform
```bash
cd terraform
terraform plan
terraform apply -auto-approve
```

## Docker
```bash
docker build -t rta-app:latest -f docker/Dockerfile .
docker run -it --rm -p 8080:8080 rta-app:latest

docker tag rta-app:lates rtaacr.azurecr.io/rta-app:0.0.1

az acr login -n rtaacr
docker image push rtaacr.azurecr.io/rta-app:0.0.1

az acr repository show-tags --name rtaacr --repository rta-app
```


## K8s
```bash
az aks get-credentials --resource-group rta-resource-group --name rta-demo-cluster --overwrite-existing

cd kubernetes
kubectl create namespace rta
kubectl apply -f deployment.yaml -f service.yaml
```
