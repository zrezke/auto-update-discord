#!/bin/bash

# Script path
script_path=$(dirname $(realpath $0))

# Point to user home directory containing .config/discord
sudo sed -i "4ihome_directory=$HOME" $script_path/update-discord.sh
sudo cp update-discord.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable update-discord.service
