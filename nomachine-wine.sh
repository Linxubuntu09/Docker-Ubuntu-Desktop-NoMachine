#!/bin/bash

# Install Chrome Remote Desktop
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
sudo apt-get --assume-yes install --fix-broken

# Authorize the user
echo "Please enter the Google account to authorize:"
read GOOGLE_ACCOUNT
sudo adduser $GOOGLE_ACCOUNT chrome-remote-desktop
sudo systemctl restart chrome-remote-desktop

# Download and extract the Chrome Remote Desktop installer
wget -O crd_installer.exe "https://dl.google.com/chrome-remote-desktop/chromeremotedesktophost.msi"
sudo apt-get --assume-yes install unzip
unzip -p crd_installer.exe > crd_installer.zip

# Install Wine for running Windows applications
sudo dpkg --add-architecture i386
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt-get update
sudo apt-get --assume-yes install winehq-stable

# Install dependencies for NoMachine
sudo apt-get --assume-yes install x11-xserver-utils xdg-utils

# Download and extract NoMachine
wget -O nomachine.deb "https://download.nomachine.com/download/7.6/Linux/nomachine_7.6.2_4_amd64.deb"
sudo dpkg --install nomachine.deb

# Connect to the remote Windows machine
echo "Please enter the name or IP address of the Windows machine:"
read WINDOWS_MACHINE
echo "Please enter the username for the Windows machine:"
read WINDOWS_USER
echo "Please enter the password for the Windows machine:"
read WINDOWS_PASSWORD
/opt/google/chrome-remote-desktop/chrome-remote-desktop --start \
    --pin=$WINDOWS_PASSWORD \
    --name=$WINDOWS_MACHINE \
    --code="akuhnetw7X64" \
    --redirect-url="https://remotedesktop.google.com/_/oauthredirect" \
    --create-session --no-host-check \
    --monitor="1920x1080" \
    --guest \
    -- bash -c "export DISPLAY=:20; wine explorer \\\\${WINDOWS_MACHINE}\\c\$"
