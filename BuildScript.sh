#!/bin/bash
/usr/local/bin/docker-compose -f docker-compose.yml up -d
docker login -u AWS -p $(aws ecr get-login-password --region ap-south-1) 765771042989.dkr.ecr.ap-south-1.amazonaws.com
docker tag clever-tap-wordpressdocker_wordpress 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:wordpress_$1
docker tag clever-tap-wordpressdocker_wordpress 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:mysql_$1
docker push 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:wordpress_$1
docker push 765771042989.dkr.ecr.ap-south-1.amazonaws.com/clever-tap:mysql_$1
