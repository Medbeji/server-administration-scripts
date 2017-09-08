#!/bin/bash


echo "creating a new ssh user"

#add new user
sudo adduser $1 

echo "user created"
#switch to user account
sudo -u $1 sh -c "cd /home/$1/; mkdir .ssh; chmod 700 .ssh; touch .ssh/authorized_keys;chmod 600 .ssh/authorized_keys" 
echo "added a user with ssh folder"

# add user to sudoers
sudo usermod -a -G sudo $1


