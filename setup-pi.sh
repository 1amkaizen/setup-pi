#!/bin/bash

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


# ================================================
# Script untuk buat swap
# ================================================

sudo mkdir -p /mnt/ramdisk
sudo chown -R pi:pi /mnt/ramdisk/
sudo mount -osize=200M -t tmpfs tmpfs /mnt/ramdisk/
sudo tee -a /etc/fstab > /dev/null <<EOF 
tmpfs /mnt/ramdisk tmpfs defaults,noatime,mode=755,uid=pi,gid=pi,size=200 0 0
EOF
sudo mount -a
df -h

# ================================================
# Script untuk login github denga ssh
# ================================================
read -p "Maasukkan Email github : " email
read -p "Maasukkan username github : " username

# tentukan path
key_path="$HOME/.ssh/id_ed25519"

# cek jika key sudah ada,konfirmasi overwrite
if [ -f "$key_path" ]; then

    	read -p "SSH key sudah ada di $key_path, Overwrite? (y/n): " confirm
    	if [[ $confirm != "y" && $confirm != "Y" ]]; then

            	echo "Proses di batalkan"

    	fi
fi

# Generate SSH key tapa passphrase
ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""

# start ssh-agent dan add key

eval "$(ssh-agent -s)"
ssh-add "$key_path"

# Tampilkan pub key
echo -e "\nSSH Public key kamu :\n"
cat "${key_path}.pub"
git config --global user.email "$email"
git config --global user.name "$username"


echo -e "\nCopy Public key di atas dan tambahkan ke https://github.com/settings/keys"

echo "Dan untuk cek sudah login gunakan perintah : ssh -T git@github.com"

# ================================================
# Script untuk setting & menginstall plugin Vim secara otomatis
# ================================================

echo "set number" | sudo tee -a /etc/vim/vimrc > /dev/null
sudo tee -a /etc/vim/vimrc > /dev/null <<EOF 
set number
set tabstop=4
EOF

echo -e "${CYAN}🔧 Menginstall Vundle (Plugin Manager Vim)...${NC}"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo -e "${YELLOW}📦 Menginstall vim-fugitive...${NC}"
sudo apt install vim-fugitive -y
echo -e "${BLUE}📦 Menginstall vim-airline...${NC}"
sudo apt install vim-airline -y
echo -e "${GREEN}✅ Semua plugin vim berhasil di Install!${NC}"













