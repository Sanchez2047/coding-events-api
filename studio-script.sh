# set HOME environment variable
export HOME=/home/student

# update apt-get repositories
sudo apt-get update

### MySQL section START ###

# download the apt-get repository source package for MySQL
wget https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb

# register the repository package with apt-get
sudo dpkg -i mysql-apt-config_0.8.15-1_all.deb

# update apt-get now that it has the new repo
sudo apt-get update

# set environment variables that are necessary for MySQL installation
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password lc-password"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password lc-password"

# install MySQL in a noninteractive way since the environment variables set the necessary information for setup
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

# create a setup.sql file which will create our database, our user, and grant our user privileges to the database
cat >> setup.sql << EOF
CREATE DATABASE coding_events;
CREATE USER 'coding_events'@'localhost' IDENTIFIED BY 'launchcode';
GRANT ALL PRIVILEGES ON coding_events.* TO 'coding_events'@'localhost';
FLUSH PRIVILEGES;
EOF

# using the mysql CLI to run the setup.sql file as the root user in the mysql database
sudo mysql -u root --password=lc-password mysql < setup.sql

### MySQL section END ###

# TODO: download and install the dotnet SDK

wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1

# set DOTNET_CLI_HOME environment variable

export DOTNET_CLI_HOME=/home/student/
export HOME=/home/student/
export DOTNET_CLI_HOME=$HOME

# TODO: clone your forked repo

#git clone https://github.com/Sanchez2047/coding-events-api.git

# TODO: change into the repo directory

cd /home/student/coding-events-api

# TODO: checkout the correct branch (2-mysql-solution)

git branch

# TODO: change into CodingEventsAPI/

cd CodingEventsAPI/

# TODO: publish source code
export DOTNET_CLI_HOME=/home/student/
export HOME=/home/student/
cd /home/student/coding-events-api/CodingEventsAPI
dotnet publish -c Release -r linux-x64 -p:PublishSingleFile=true

# deploy application by running the published executable
# this assumes your CWD is /home/student/coding-events-api/CodingEventsAPI
export DOTNET_CLI_HOME=/home/student/
export HOME=/home/student/
cd /home/student/coding-events-api/CodingEventsAPI
ASPNETCORE_URLS="http://*:80" ./bin/Release/netcoreapp3.1/linux-x64/publish/CodingEventsAPI