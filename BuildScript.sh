#!/bin/bash
/usr/local/bin/docker-compose -f docker-compose.yml up -d
aws ecr get-login-password --region ap-south-1 | docker login --username AWS  --password-stdin 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap
docker tag clever-tap-wordpressdocker_wordpress 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:wordpress_$1
docker tag clever-tap-wordpressdocker_wordpress 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:mysql_$1
docker push 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:wordpress_$1
docker push 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:mysql_$1
