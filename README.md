## Terraform
```bash
terraform plan
terraform apply -auto-approve
```

## K8s
```bash
az aks get-credentials --resource-group rta-resource-group --name rta-demo-cluster
```

## Docker
```bash
docker build -t rtaacr.azurecr.io/rta-app:0.0.1 -f docker/Dockerfile .
docker run -it --rm -p 8080:8080 rtaacr.azurecr.io/rta-app:0.0.1

az acr login -n rtaacr
docker image push rtaacr.azurecr.io/rta-app:0.0.1
```
