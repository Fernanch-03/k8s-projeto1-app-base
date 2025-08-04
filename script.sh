#!/bin/bash

echo "criando as imagens"


docker build -t k8s-projeto1-app-base-database:latest -f database/Dockerfile .
docker build -t k8s-projeto1-app-base-backend:latest -f backend/Dockerfile .

echo "realizando push das imagens"

docker push k8s-projeto1-app-base-backend:latest
docker push k8s-projeto1-app-base-database:latest

echo "criando serviços no cluser kubernetes"

kubectl apply -f services.yml

echo "criando deployments no cluster kubernetes"

kubectl apply -f deployment.yml
