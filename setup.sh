# Update & install dependencies
sudo yum -y update
sudo yum -y install postgresql postgresql-server

# Initialize PostgreSQL database and start service
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create Kong database and user
sudo -u postgres psql -c 'CREATE DATABASE kong;'
sudo -u postgres psql -c 'CREATE USER kong;'
sudo -u postgres psql -c 'ALTER USER kong WITH PASSWORD '';''
sudo -u postgres psql -c 'GRANT ALL PRIVILEGES ON DATABASE kong TO kong;'

# Install Kong
sudo yum -y install https://bintray.com/kong/kong-rpm/rpm -O /etc/yum.repos.d/bintray-kong-kong-rpm.repo
sudo yum -y install kong

# Bootstrap and start Kong
sudo kong migrations bootstrap -c /etc/kong/kong.conf
sudo kong start -c /etc/kong/kong.conf
