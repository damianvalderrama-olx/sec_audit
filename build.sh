#!/bin/bash

image=kalilinux/kali-linux-docker
docker images $image:latest | awk -v image="$image" -F " " '$3 !~ /IMAGE/ {
if (length($5) == 0)
printf "Required" image "is missing. Installation will take place"
system("docker pull "image":latest");
if ( $5 != "days" )
printf $1" "$2" might be outdated. Created "$4" "$5" "$6".\n"
printf "Do you want to check & update to latest available image if possible? [Y/N]"
getline choice < "/dev/tty"
if ( choice == "Y" || choice == "y" )
system("docker pull "image":latest")
}'

# Delete previous container for sec_audit

docker stop sec_audit
docker rm sec_audit

# Create Docker Image

docker build -t "sec_audit:1.0" .

# Start container with :
#	Port mapping= 8000:8000
#	Name= sec_audit
#	Entrypoint= /bin/bash [from Dockerfile]
#	Detached= YES

docker run -t -i -d -p 8000:8000 --name sec_audit sec_audit:1.0

# Start postgresql and configure user/role/database

docker cp apps_config/postgresql.gpg sec_audit:/tmp/postgresql
docker exec sec_audit /bin/bash -c "service postgresql start"
docker exec sec_audit /bin/bash -c "chown postgres:postgres /tmp/postgresql; chmod +x /tmp/postgresql"
docker exec --user postgres sec_audit /bin/bash -c "/tmp/postgresql"
docker exec sec_audit /bin/bash -c "rm /tmp/postgresql"

# Gitrob setup

docker cp apps_config/gitrobrc.gpg sec_audit:/root/.gitrobrc

# Start Gitrob daemon

docker exec sec_audit /bin/bash -c "gitrob server -d --bind-address=127.0.0.1 --port=8000"
