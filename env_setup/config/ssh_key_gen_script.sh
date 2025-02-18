#!/bin/bash

# ssh_key_gen_script.sh
# Script to generate a new SSH key and add it to the ssh-agent for GitHub

# Prompt user for details
read -p "Enter your email (for SSH key comment): " email
read -p "Choose the algorithm (rsa/ed25519) [default: ed25519]: " algorithm
algorithm=${algorithm:-ed25519}  # Default to ed25519 if empty

if [ "$algorithm" != "ed25519" ] && [ "$algorithm" != "rsa" ]; then
    echo "Invalid algorithm. Choose 'rsa' or 'ed25519'."
    exit 1
fi

# Set key size for RSA
if [ "$algorithm" = "rsa" ]; then
    read -p "Enter key size (e.g., 2048, 4096) [default: 4096]: " key_size
    key_size=${key_size:-4096}  # Default to 4096 if empty
fi

read -s -p "Enter a passphrase (leave empty for no passphrase): " passphrase
echo ""

# Define key file
key_file="$HOME/.ssh/id_$algorithm"

# Generate the SSH key
if [ "$algorithm" = "ed25519" ]; then
    ssh-keygen -t "$algorithm" -C "$email" -N "$passphrase" -f "$key_file"
else
    ssh-keygen -t "$algorithm" -b "$key_size" -C "$email" -N "$passphrase" -f "$key_file"
fi

# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# Add the SSH key to the ssh-agent
ssh-add "$key_file"

# Display public key for copying
echo -e "\e[1;33mCopy the SSH public key and add it to GitHub:\e[0m"
cat "$key_file.pub"

echo -e "\n\e[1;32mYour SSH key has been generated and added to ssh-agent.\e[0m"
echo -e "\e[1;32mYou can now add the public key to your GitHub account.\e[0m"