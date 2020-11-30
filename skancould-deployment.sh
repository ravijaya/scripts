#!/bin/bash

################################################################################
#
# Script to deploy Skan Cloud
#
################################################################################


################################################################################
#	Functions for the input validations
################################################################################

function check_for_empty {
    if [[ -z $2 ]]; then
	       echo "$0: $1: input cannot be empty"
         exit 2
    fi
}


function check_for_fqdn {
    echo $2 | grep -Pq '(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'

    if (( $? == 1)); then
         echo "$0:$1 is not a FQDN:$2"
	       exit 1
    fi
}


################################################################################
# Initalizing GIT Credentials
################################################################################
export GITUSER=ravi.jaya
export GITPASSWORD=gkme6jop5kttajmfspvfn35tae2o3w5agwyy6god56guky3g75aa


echo -n  'enter the server name :'
read servername
check_for_empty ServerName $servername
# check_for_fqdn ServerName $servername

echo -n  'enter the gateway port:'
read gatewayport
check_for_empty "Gateway Port" $gatewayport

echo -n 'enter the MongoDB Server :'
read dbserver
check_for_empty "MongoDB Server" $dbserver
# check_for_fqdn "MongoDB Server" $dbserver

echo -n 'enter the MongoDB Port :'
read port
check_for_empty "MongoDB Port" $port

echo -n 'enter the MongoDB Username :'
read username
check_for_empty "MongoDB Username" $username

echo -n 'enter the MongoDB Password :'
read -s password
check_for_empty "MongoDB Password" $password
echo; echo

platform_api_path=platform_api
platform_api_path=""


cat <<EOF > $HOME/$platform_api_path/env.list
SERVERNAME=$servername
GATEWAYPORT=$gatewayport
ROOTDIR=/home/cpxroot
DATABASE=mongodb://${dbserver}:${port}/
USERNAME=$username
PASSWORD=$password
MONGODB_SERVER=$dbserver
MONGODB_PORT=$port
MONGODB_USERNAME=$username
MONGODB_PASSWORD=$password
EOF

export SERVERNAME=$servername
export GATEWAYPORT=$gatewayport
export ROOTDIR=/home/cpxroot
export DATABASE=mongodb://${dbserver}:${port}/
export USERNAME=$username
export PASSWORD=$password
export MONGODB_SERVER=$dbserver
export MONGODB_PORT=$port
export MONGODB_USERNAME=$username
export MONGODB_PASSWORD=$password

git clone -b dev https://$GITUSER:$GITPASSWORD@dev.azure.com/skancore/skan/_git/devOps

cd devOps

sed -i -re 's/user:".+"/user:"'$MONGODB_USERNAME'"/' \
       -re 's/password:".+"/password:"'MONGODB_PASSWORD'"/' mongodb/init-init-mongo.js

docker-compose -f mongodb/docker-compose.yml up --build -d
mongodb_service=$(docker-compose -f mongodb/docker-compose.yml ps | wc -l)

if [[ $mongodb_service -gt 0 ]]; then
    docker-compose -f mongodb/docker-compose.yml ps
else
    echo -e "\e[31m\e[1mMongoDB Failed to start, exiting...\e[0m"
    exit
fi

echo
echo
