#!/bin/bash

# Script to automate PostgreSQL installation and setup

# Variables
POSTGRESQL_PASSWORD="admin@123"
DATABASE_NAME="springbootdb"
LISTEN_ADDRESSES="*"
HBA_CONFIG="host  all  all  0.0.0.0/0  md5"

echo "Updating package lists..."
apt update -y

echo "Installing PostgreSQL..."
apt install -y postgresql postgresql-client

echo "Restarting PostgreSQL service..."
systemctl restart postgresql.service

echo "Setting PostgreSQL password..."
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRESQL_PASSWORD}';"

echo "Detecting installed PostgreSQL version..."
POSTGRESQL_VERSION=$(psql -V | awk '{print $3}' | cut -d. -f1)
POSTGRESQL_CONF="/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf"

echo "Getting PostgreSQL configuration file paths..."
HBA_FILE=$(sudo -u postgres psql -t -P format=unaligned -c "SHOW hba_file;")

echo "Configuring PostgreSQL to listen on all addresses..."
sed -i "s/^#listen_addresses.*/listen_addresses = '${LISTEN_ADDRESSES}'/" $POSTGRESQL_CONF

echo "Updating pg_hba.conf to allow remote connections..."
echo "$HBA_CONFIG" >> $HBA_FILE

echo "Restarting PostgreSQL service to apply changes..."
systemctl restart postgresql.service
systemctl status postgresql.service --no-pager

echo "Creating database ${DATABASE_NAME}..."
sudo -u postgres psql -c "CREATE DATABASE ${DATABASE_NAME};"

echo "Verifying the database creation..."
sudo -u postgres psql -c "\l"

echo "PostgreSQL setup completed successfully!"
