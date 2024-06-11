#!/usr/bin/env bash

# Default packages are for the configuration and corresponding .config folders
# Install packages after installing base Debian with no GUI

# xorg display server installation
# sudo apt install -y xorg xserver-xorg xbacklight xbindkeys xvkbd xinput
# Below command works for debian 12.5. Else, I was facing Xorg issues.
sudo apt install -y xorg xserver-xorg-core xserver-xorg-video-amdgpu xinit xinput x11-xserver-utils x11-utils xbacklight xbindkeys xvkbd

# PACKAGE INCLUDES build-essential.
sudo apt install -y build-essential

# Create folders in user directory (eg. Documents,Downloads,etc.)
xdg-user-dirs-update
mkdir ~/Screenshots/

# PICK YOUR X11 Window Managers (Uncomment if you want these installed)
bash ~/bookworm-scripts/resources/bspwm-commands
# bash ~/bookworm-scripts/resources/dk-commands
# bash ~/bookworm-scripts/resources/dwm-commands
# bash ~/bookworm-scripts/resources/qtile-commands
# bash ~/bookworm-scripts/resources/i3-commands

# XFCE4 Minimal
# sudo apt install -y xfce4 xfce4-goodies

# Network File Tools/System Events
sudo apt install -y dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends xfce4-power-manager

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Networking etc
sudo apt install -y policykit-1-gnome network-manager network-manager-gnome

# Thunar
sudo apt install -y thunar thunar-archive-plugin thunar-volman file-roller

# Terminal (eg. terminator,kitty,xfce4-terminal)
sudo apt install -y kitty tilix 

# Sound packages
sudo apt install -y pulseaudio alsa-utils pavucontrol volumeicon-alsa pamixer

# Neofetch
sudo apt install -y neofetch

# Installation for Appearance management
sudo apt install -y lxappearance 

# Browser Installation - Firefox & Chrome
sudo apt install -y firefox-esr 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# Desktop background browser/handler 
# feh --bg-fill /path/to/directory 
# sudo apt install -y nitrogen 
sudo apt install -y feh

# Fonts and icons for now
sudo apt install -y fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus papirus-icon-theme

# EXA installation
# replace ls command in .bashrc file with line below
# alias ls='exa -al --long --header --color=always --group-directories-first' 
sudo apt install -y exa


# Printing
# sudo apt install -y cups system-config-printer simple-scan
# sudo systemctl enable cups

# Bluetooth
sudo apt install -y bluez blueman
sudo systemctl enable bluetooth

# Packages needed for window manager installation
sudo apt install -y picom rofi dunst libnotify-bin unzip wmctrl xdotool libnotify-dev

# Geany Text Editor, text editor, markdown editor
# sudo apt install -y geany 
# sudo apt install -y geany-plugin-addons geany-plugin-git-changebar geany-plugin-overview geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-vimode
# sudo apt install -y geany-plugins \ # all plugins
# sudo apt install -y mousepad ghostwriter
# sudo apt install -y l3afpad

# PDF 
# sudo apt install -y  evince pdfarranger

# Others
# sudo apt install -y numlockx figlet galculator cpu-x udns-utils whois curl tree
sudo apt install -y galculator whois curl tree

# Screenshots - Flameshot
sudo apt install flameshot

# Install Lightdm Console Display Manager
sudo apt install -y lightdm lightdm-gtk-greeter-settings
sudo systemctl enable lightdm

# Betterlockscreen
# Check link below and install it
# https://github.com/betterlockscreen/betterlockscreen

# Install the Ly Console Display Manager
# bash ~/bookworm-scripts/ly.sh


########################################################
# End of script for default config
#

## These two scripts will install nerdfonts and copy my configuration files into the ~/.config directory
## Configuration uses 

bash ~/bookworm-scripts/resources/nerdfonts.sh

\cp ~/bookworm-scripts/resources/.bashrc ~


sudo apt autoremove

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"
