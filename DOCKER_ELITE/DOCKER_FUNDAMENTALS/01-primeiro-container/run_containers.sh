#!/bin/bash

echo ">>> Baixando a imagem do Nginx..."
docker pull nginx
echo ">>> Iniciando o container do Nginx meu_servidor"
docker run -d --name meu_servidor nginx
echo ">>> Listando containers em execução..."
docker ps 
echo ">>> Parando o container meu_servidor"
docker stop meu_servidor
echo ">>> Removendo o container meu_servidor"
docker rm meu_servidor
echo ">>> Listando containers"
docker ps -a
