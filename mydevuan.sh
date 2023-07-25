#!/bin/bash

statusStr="mydevuan"

getCol() {
    IFS=';' read -sdR -p $'\E[6n' ROW COL
    echo $((COL-1))
}

draw() {
    echo -e "\033[1;1H"

    cols=$(tput cols)
    num_dashes=$(($cols / 2 - $((${#statusStr} / 2 + 1))))

    if (( num_dashes > 0 )); then
        printf '%*s' "$num_dashes" '' | tr ' ' "-"
    else
        echo "Not enough columns for dashes"
    fi

    printf " "
    echo -n $statusStr
    printf " "

    printf '%*s' "$num_dashes" '' | tr ' ' "-"

    while [ $(getCol) -ne $cols ]
    do
        printf "-"
    done
}

sudo echo "Starting..."
clear
draw

# Add the bookworm apt repo
echo "Adding the bookworm APT repository..."
echo -e "\ndeb http://deb.debian.org/debian/ bookworm main non-free-firmware" | sudo tee -a /etc/apt/sources.list
sudo apt update

# Install nala
echo "Installing nala..."
sudo apt install -y nala

# Remove the bookworm apt repo
echo "Removing the bookworm APT repository..."
sudo sed -i '/deb http:\/\/deb.debian.org\/debian\/ bookworm main non-free-firmware/d' /etc/apt/sources.list
sudo apt update

# Configure nala
echo "Configuring nala..."
sudo nala fetch
sudo nala update

# Install git
echo "Installing git..."
sudo nala install -y git

# Install XFCE (minimal)
echo "Installing XFCE (minimal)..."
sudo nala install -y xfce4 --no-install-recommends

# Install lightDM
echo "Installing lightDM..."
sudo nala install -y lightdm

# Install kitty (terminal)
echo "Installing kitty..."
sudo nala install -y kitty

# Install Firefox ESR
echo "Installing Firefox ESR..."
sudo nala install -y firefox-esr

# Install VIM
echo "Installing VIM..."
sudo nala install -y vim

# Install neofetch (minimal)
echo "Installing neofetch (minimal)..."
sudo nala install -y neofetch --no-install-recommends

# Install wget
echo "Installing wget..."
sudo nala install -y wget

# Install discord
echo "Installing discord..."
wget https://dl.discordapp.net/apps/linux/0.0.28/discord-0.0.28.deb
sudo nala install -y ./discord-0.0.28.deb
rm discord-0.0.28.deb

# Install VScode
echo "Installing VScode..."
wget https://az764295.vo.msecnd.net/stable/74f6148eb9ea00507ec113ec51c489d6ffb4b771/code_1.80.1-1689183569_amd64.deb
sudo nala install -y ./code_1.80.1-1689183569_amd64.deb
rm code_1.80.1-1689183569_amd64.deb

# Install GCC
echo "Installing GCC..."
sudo nala install -y gcc

# Install nasm
echo "Installing nasm..."
sudo nala install -y nasm

# Install make
echo "Installing make..."
sudo nala install -y make

# Install ruby
echo "Installing ruby..."
sudo nala install -y ruby

# Install python3
echo "Installing python3..."
sudo nala install -y python3

# Install QEMU (qemu-utils and qemu-system-x86)
echo "Installing QEMU utilities and qemu-system-x86"
sudo nala install -y qemu-utils qemu-system-x86

# Install GitHub CLI
echo "Installing GitHub CLI..."
type -p curl >/dev/null || (sudo nala update && sudo nala install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo nala update
sudo nala install -y gh

# Install yadyn
echo "Installing yadyn..."
wget https://github.com/z-izz/yadyn/releases/download/v20230720113224/yadyn.deb
sudo nala install -y ./yadyn.deb
rm yadyn.deb

# Install yass
echo "Installing yass..."
wget https://github.com/z-izz/yass/releases/download/v1.0.0/yass-v1.0.0.deb
sudo nala install -y ./yass-v1.0.0.deb
rm yass-v1.0.0.deb

# Download yadyn theme
echo "Downloading yadyn theme..."
wget https://github.com/z-izz/yadyn/raw/zi/thatch.tar.gz -O /home/$(whoami)/thatch.tar.gz
mkdir -p /home/$(whoami)/.yadyntheme
tar -xzvf /home/$(whoami)/thatch.tar.gz -C /home/$(whoami)/.yadyntheme
rn /home/$(whoami)/thatch.tar.gz

# Download xfce4-chicago95 GTK theme
echo "Downloading xfce4-chicago95 GTK theme..."
wget https://github.com/Winksplorer/mydevuan/raw/main/xfce4-chicago95.tar.gz -O /home/$(whoami)/xfce4-chicago95.tar.gz
sudo mkdir -p /usr/share/themes
sudo tar -xzvf /home/$(whoami)/xfce4-chicago95.tar.gz -C /usr/share/themes/
rm /home/$(whoami)/xfce4-chicago95.tar.gz

# Download PlatiPlus26 XFWM theme
echo "Downloading PlatiPlus26 XFWM theme..."
wget https://github.com/Winksplorer/mydevuan/raw/main/PlatiPlus26.tar.gz -O /home/$(whoami)/PlatiPlus26.tar.gz
sudo tar -xzvf /home/$(whoami)/PlatiPlus26.tar.gz -C /usr/share/themes/
rm /home/$(whoami)/PlatiPlus26.tar.gz

# Download fonts
echo "Downloading fonts..."
wget https://github.com/Winksplorer/mydevuan/raw/main/fonts.tar.gz -O /home/$(whoami)/fonts.tar.gz
mkdir -p /home/$(whoami)/.fonts
tar -xzvf /home/$(whoami)/fonts.tar.gz -C /home/$(whoami)/.fonts/
rm /home/$(whoami)/fonts.tar.gz

# Download os9 icon pack
echo "Downloading os9 icon pack..."
wget https://github.com/Winksplorer/mydevuan/raw/main/os9-icons.tar.gz -O /home/$(whoami)/os9-icons.tar.gz
sudo mkdir -p /usr/share/icons
sudo tar -xzvf /home/$(whoami)/os9-icons.tar.gz -C /usr/share/icons/
rm /home/$(whoami)/os9-icons.tar.gz

# Download the postinstall script
echo "Downloading the postinstall script..."
wget https://raw.githubusercontent.com/Winksplorer/mydevuan/main/postinstall.sh -O /home/$(whoami)/.postinstall.sh

# Add the postinstall script to xfce login-autorun
echo "Adding the postinstall script to XFCE autorun..."
app_name="mydevuan-postinstall"
app_command="/home/$(whoami)/.postinstall.sh"
mkdir -p ~/.config/autostart
echo -e "[Desktop Entry]\nType=Application\nExec=$app_command\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[en_US]=$app_name\nName=$app_name\nComment[en_US]=\nComment=" > ~/.config/autostart/$app_name.desktop

# Set XFCE as default desktop in lightDM
echo "Setting XFCE as default desktop in lightDM..."
session_name="xfce"
dmrc_path="/home/$(whoami)/.dmrc"
touch $dmrc_path
if ! grep -q "\[Desktop\]" $dmrc_path; then
    echo -e "[Desktop]\nSession=" >> $dmrc_path
fi
sed -i 's/^Session=.*/Session='$session_name'/' $dmrc_path
chmod 600 $dmrc_path

# Reboot so we can enter the postinstall
echo "Rebooting..."
sleep 1
sudo reboot