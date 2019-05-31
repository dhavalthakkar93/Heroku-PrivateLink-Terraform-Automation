#!/bin/sh
curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get -qq update && sudo apt-get install -y curl ca-certificates
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get -qq update
sudo apt-get install -y postgresql-client-10
sudo apt install postgresql-client-common

