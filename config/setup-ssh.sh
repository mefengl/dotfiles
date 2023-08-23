#!/bin/bash

set -e

# Prompt for server details
read -p "Enter the server name used for SSH: " server_name
read -p "Enter the server IP address: " ip_address
read -p "Enter the server user (usually root): " user
read -p "Enter the key name: " key_name

if [ -z "$key_name" ]; then
  echo "Key name is required. Exiting."
  exit 1
fi

# Construct key path
key_path="$HOME/ssh_keys/$key_name.pem"

# Generate SSH key pair
echo "Generating SSH key pair..."
mkdir -p $HOME/ssh_keys
ssh-keygen -t rsa -b 4096 -f $key_path

# Add entry to SSH config file
echo "Configuring SSH client..."
echo "Host $server_name
  HostName $ip_address
  Port 22
  User $user
  IdentitiesOnly yes
  IdentityFile $key_path" | sudo tee -a $HOME/.ssh/config > /dev/null

# Copy public key to server
echo "Copying public key to server..."
ssh-copy-id -i $key_path.pub $user@$ip_address

echo "Setup complete! You can now use 'ssh $server_name' to log in without a password."
