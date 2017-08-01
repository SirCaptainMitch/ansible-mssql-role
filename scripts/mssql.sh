#!/bin/bash

set -e # Exit script immediately on first error.
set -x # Print commands and their arguments as they are executed.

# Check if SQL Server environment is already installed
RUN_ONCE_FLAG=~/.mssqlserver_env_build_time

if [ -e "$RUN_ONCE_FLAG" ]; then
  echo "SQL Server environment is already installed."
  exit 0
fi

##
# Sqlserver tools - https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-ubuntu
##

# 1. imports and registers public repository
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | sudo tee /etc/apt/sources.list.d/mssql-server.list

# 2. installs package
sudo apt-get update -y
sudo apt-get install -y mssql-server

# 3. configures database
# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables
sudo ACCEPT_EULA='Y' MSSQL_PID='Developer' MSSQL_SA_PASSWORD='HardPass2017!' MSSQL_TCP_PORT=1433 /opt/mssql/bin/mssql-conf setup
# 4. starts database instance
sudo systemctl start mssql-server

##
# Sqlserver tools - https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools#ubuntu
##

# Import the public repository GPG keys:
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft Ubuntu repository:
sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)"

# Update the sources list and run the installation command with the unixODBC developer package:
sudo apt-get update
sudo apt-get install -y -f -q mssql-tools unixodbc-dev

# set env path variables 
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

# connect test 
sqlcmd -S localhost -U SA -P 'HardPass2017!'


sudo ACCEPT_EULA=y DEBIAN_FRONTEND=noninteractive apt-get install -y -f -q --no-install-recommends mssql-tools unixodbc-dev