#!/bin/bash

echo "Criando o volume"
docker volume create nginx_logs

echo "Iniciando o container nginx_server, sleep de 3 segundos e acessando a página inicial 2 vezes"
docker run -d --name nginx_server -p 8080:80 -v nginx_logs:/var/log/nginx nginx
sleep 3
curl http://localhost:8080
curl http://localhost:8080

echo "Acessando os logs do container e salvando no volume"
docker logs nginx_server 2>&1 | docker exec -i nginx_server sh -c 'cat > /var/log/nginx/logs_persistentes.log'
docker exec nginx_server sh -c 'echo "     Fim log container nginx_server" >> /var/log/nginx/logs_persistentes.log'

echo "Mostrando o conteúdo do arquivo de logs"
docker exec nginx_server cat /var/log/nginx/logs_persistentes.log

echo "Removendo o container nginx_server e criando o nginx_server2"
docker rm -f nginx_server
docker run -d --name nginx_server2 -p 8080:80 -v nginx_logs:/var/log/nginx nginx
sleep 3

echo "Acessando o arquivo de logs pelo nginx_server2"
docker exec nginx_server2 sh -c 'echo "       Acessando os logs persistidos no nginx_server2! \o/ " >> /var/log/nginx/logs_persistentes.log'
docker exec nginx_server2 cat /var/log/nginx/logs_persistentes.log

echo "Removendo o container nginx_server2 e o volume nginx_logs"
docker rm -f nginx_server2
docker volume rm nginx_logs