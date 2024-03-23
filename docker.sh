#!/bin/bash

cp -frv ${HOME}/.aws ./
cp -frv ${HOME}/.gitconfig ./

docker build -t demo .
docker run -dit --name demo -v ./src:/root/work/src -d demo /bin/bash
docker ps -a
docker exec -it demo /bin/bash
rm -frv .aws
rm -frv .config