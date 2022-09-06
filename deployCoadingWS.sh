#!/bin/sh
#Checking whether VNC password is passed to script
vncPassword=$2;
[ -z "$vncPassword" ] && echo "###Please pass VNC password...!!!">deployCoadingWS.log && exit 0 || echo "Successfully got VNC password...">deployCoadingWS.log;

#Checking whether username is passed to script
#A docker folder will be created inside this users home directory and container persistant data will be stored there
dockerUser=$1;
[ -z "$dockerUser" ] && echo "###Please pass username...!!!">>deployCoadingWS.log && exit 0 || echo "Deploying container for user $dockerUser">>deployCoadingWS.log;

#Checking & Removing existing container
echo "Checking if coadingws already deployed...">>deployCoadingWS.log;
container=$(docker ps -q --filter ancestor=coadingws )>>deployCoadingWS.log;
[ -z "$container" ] && echo "No running container found">>deployCoadingWS.log || docker rm -f $container;

#Building image
echo "Building coadingws image...">>deployCoadingWS.log;
docker build . --file Dockerfile --tag coadingws;
echo "Image build successfully...">>deployCoadingWS.log;

#Deploying container
echo "Deploying VScode...">>deployCoadingWS.log;
docker run -d -p 49152:6901 -e VNC_PW=$vncPassword --restart=always -v /home/$dockerUser/docker/CoadingWS/kasm-user:/home/kasm-user --name coadingwscontainer coadingws;
echo "coadingws deployment successfull...">>deployCoadingWS.log;
exit 0