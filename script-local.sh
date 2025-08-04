#!/bin/bash

echo "===== Script de Deploy Local ====="

echo "1. Criando as imagens Docker..."

# Build da imagem do database
echo "Building imagem database..."
docker build -t k8s-projeto1-app-base-database:latest -f database/Dockerfile .

# Build da imagem do backend
echo "Building imagem backend..."
docker build -t k8s-projeto1-app-base-backend:latest -f backend/Dockerfile .

echo "2. Verificando se as imagens foram criadas..."
docker images | grep k8s-projeto1-app-base

echo "3. Executando os containers localmente (sem Kubernetes)..."

# Para o containers se já estiverem rodando
docker stop k8s-database k8s-backend 2>/dev/null || true
docker rm k8s-database k8s-backend 2>/dev/null || true

# Executa o container do database
echo "Iniciando container do database..."
docker run -d \
    --name k8s-database \
    -p 3306:3306 \
    k8s-projeto1-app-base-database:latest

# Aguarda o database inicializar
echo "Aguardando database inicializar..."
sleep 10

# Executa o container do backend
echo "Iniciando container do backend..."
docker run -d \
    --name k8s-backend \
    -p 8080:80 \
    --link k8s-database:mysql \
    k8s-projeto1-app-base-backend:latest

echo "4. Verificando status dos containers..."
docker ps

echo ""
echo "===== Deploy Local Completo! ====="
echo "Acesse a aplicação em: http://localhost:8080"
echo "Database disponível em: localhost:3306"
echo ""
echo "Para parar os containers execute:"
echo "docker stop k8s-database k8s-backend"
echo "docker rm k8s-database k8s-backend"
