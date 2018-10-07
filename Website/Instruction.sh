54.86.40.115


1) Create Cloud9 Env
2) Assign permission to HTTP->Anywhere to Security Group
3) Copy the Public IP
4)

mkdir webapp && cd ./webapp
wget http://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-100-DODEVA/v3.0.1/lab-6-docker/scripts/website.zip
unzip website.zip && rm -f website.zip
cd ..

vi Dockerfile
FROM ubuntu

# Install apache and remove the list of packages downloaded from apt-get update
RUN apt-get update -y && \
apt-get install -y apache2 && \
rm -r /var/lib/apt/lists/*

# Copy the website into the apache web root directory
COPY webapp /var/www/html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]

#Return to bash
docker build -t webapp-image .

#We have created an image, check:

docker images


#Running a container:
docker run --name webapp -d -p 80:80 webapp-image

#Check:

docker ps -a

#Container is running:
http://<public-ip>


#-----Interacting with the container------
docker exec -i -t webapp /bin/bash


#----Stop the container------

docker stop <container-id>


#----Start again the container -----

docker start webapp

docker logs webapp

docker port webapp

#----- Creating the ECR --------

aws ecr create-repository --repository-name webapp

#Repo Uri: 249540667242.dkr.ecr.us-east-1.amazonaws.com/webapp

#----- Tag ------

docker tag webapp-image 249540667242.dkr.ecr.us-east-1.amazonaws.com/webapp


#-----

eval $(aws ecr get-login --no-include-email)

#-----
docker push 249540667242.dkr.ecr.us-east-1.amazonaws.com/webapp
