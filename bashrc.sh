#!/bin/bash

############################################################################
#+------------------------------------------------------------------------+#
#|          Just a small script to install basic alias in .bashrc         |#
#|                                                                        |#
#|                     Copyright (C) 2023, Eylexander                     |#
#|                                                                        |#
#|   This program is free software: you can redistribute it and/or modify |#
#|   it under the terms of the GNU General Public License as published by |#
#|     the Free Software Foundation, either version 3 of the License, or  |#
#|                    (at your option) any later version.                 |#
#|                                                                        |#
#|      This program is distributed in the hope that it will be useful,   |#
#|      but WITHOUT ANY WARRANTY; without even the implied warranty of    |#
#|       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the     |#
#|               GNU General Public License for more details.             |#
#|                                                                        |#
#|     You should have received a copy of the GNU General Public License  |#
#|                   along with this program.  If not, see                |#
#|                    <https://www.gnu.org/licenses/>.                    |#
#+------------------------------------------------------------------------+#
############################################################################

URLs=(
    "https://gist.githubusercontent.com/RobSeder/c82358b06cc2b98749de/raw/174eb25ce3791ea5a1c499b481ad8bb8d9f74c48/.bashrc" # Raspbian
    "https://gist.githubusercontent.com/marioBonales/1637696/raw/93a33aa5f1893f46773483250214f8b8b496a270/.bashrc" # Ubuntu
    "https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-ISO/main/airootfs/root/endeavouros-skel-liveuser/src/etc/skel/.bashrc" # EndeavourOS
    "https://gist.githubusercontent.com/techn0punk/4882cf2b607b3aeb7f863e6040ac9ac2/raw/61d9487f82810279b6b7f2231b695b42c3a3d2ed/kali-bashrc" # Kali
)

OSNames=(
    "Raspbian GNU/Linux"
    "Ubuntu"
    "EndeavourOS"
    "Kali GNU/Linux"
)

USER=$(logname)

if [ ! -f /home/$USER/.bashrc ]; then
    echo "[Info] Creating .bashrc file"
    touch /home/$USER/.bashrc
fi

function addAliasesToFile() {
    echo "[Info] Adding alias to .bashrc file"
    echo "" >> /home/$USER/.bashrc
    echo "# Custom Aliases" >> /home/$USER/.bashrc
    echo "" >> /home/$USER/.bashrc
    echo "# VPN Settings" >> /home/$USER/.bashrc
    echo "alias showVPNkeys='echo "==== VPN Keys ====" && echo -n "PublicKey = " && sudo cat /etc/wireguard/publickey && echo -en "PrivateKey = " && sudo cat /etc/wireguard/privatekey && echo "=================="'" >> /home/$USER/.bashrc
    echo "alias showVPNconf='echo "==== VPN Config ====" && sudo cat /etc/wireguard/wg0.conf && echo "==================="'" >> /home/$USER/.bashrc
    echo "alias showVPNstatus='echo "==== VPN Status ====" && sudo wg && echo "===================="'" >> /home/$USER/.bashrc
    echo "alias showVPNclients='echo "==== VPN Clients ====" && sudo wg show wg0 latest-handshakes && echo "===================="'" >> /home/$USER/.bashrc
    echo "alias showVPNqrcode='echo "==== VPN QRCode ====" && sudo qrencode -t ansiutf8 < /etc/wireguard/publickey && echo "===================="'" >> /home/$USER/.bashrc
    echo "alias editVPNconf='sudo nano /etc/wireguard/wg0.conf'" >> /home/$USER/.bashrc
    echo "alias startVPN='sudo systemctl start wg-quick@wg0.service && echo "==== VPN Started ===="'" >> /home/$USER/.bashrc
    echo "alias stopVPN='sudo systemctl stop wg-quick@wg0.service && echo " ==== VPN Stopped ===="'" >> /home/$USER/.bashrc
    echo "alias restartVPN='sudo systemctl restart wg-quick@wg0.service && echo "VPN Restarted"'" >> /home/$USER/.bashrc
    echo "alias startTemporaryVPN='startVPN && echo "VPN will stop in 1 minutes" && sleep 60 && stopVPN'" >> /home/$USER/.bashrc

    echo "[Info] VPN Settings added to .bashrc file!"

    echo "" >> /home/$USER/.bashrc
    echo "# Bashrc Commands" >> /home/$USER/.bashrc
    echo "alias editBashrc='cd && sudo nano .bashrc; source .bashrc'" >> /home/$USER/.bashrc
    echo "alias sourceBashrc='source /home/$USER/.bashrc'" >> /home/$USER/.bashrc

    echo "[Info] Bashrc Commands added to .bashrc file!"

    echo "" >> /home/$USER/.bashrc
    echo "# Random Linux Commands" >> /home/$USER/.bashrc
    echo "alias getExternalIP='echo "==== External IP ====" && curl https://ipinfo.io/ip && echo "===================="'" >> /home/$USER/.bashrc
    echo "alias getInternalIP='echo "==== Internal IP ====" && hostname -I && echo "===================="'" >> /home/$USER/.bashrc
    echo "alias getHostname='echo "==== Hostname ====" && hostname && echo "===================="'" >> /home/$USER/.bashrc
    echo "alias connectProxmoxVPN='startVPN && nohup xdg-open https://192.168.1.88:8006 > /dev/null 2>&1 && echo "Proxmox launched in browser!"'" >> /home/$USER/.bashrc
    echo "alias connectProxmox='nohup xdg-open https://192.168.1.88:8006 > /dev/null 2>&1 && echo "Proxmox launched in browser!"'" >> /home/$USER/.bashrc
    echo "alias turnOFF='echo \"Are you sure you want to shutdown? [Y/n]\" && read confirm && [ $confirm -eq "y" ] || [ $confirm -eq "Y" ] && echo "[Info] Shutdown initiated" && shutdown -h now || echo "[Info] Shutdown cancelled"'" >> /home/$USER/.bashrc
    
    echo "[Info] Random Linux Commands added to .bashrc file!"

    echo "[Info] Reloading .bashrc file"
    source /home/$USER/.bashrc
    echo "[Info] Done!"

    echo "[Info] Installation completed!"
}

function cleanFile() {
    echo "[Info] Checking linux distribution"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    fi

    for os in "${OSNames[@]}"
    do
        if [ "$OS" == "$os" ]; then
            echo "[Info] Deleting .bashrc file"
            rm /home/$USER/.bashrc
            echo "[Info] Creating new .bashrc file"
            if wget -q ${URLs[$i]} -O /home/$USER/.bashrc; then
                echo "[Info] .bashrc file successfully written"
            else
                echo "[Error] Failed to write .bashrc file"
            fi
            break
        fi
        i=$((i+1))
    done

    if [ $i -eq ${#OSNames[@]} ]; then
        echo "[Error] Your linux distribution is not supported"
        exit
    fi
}

echo "[Info] How do you want to proceed?"
echo "[Info] 1. Hard reset of .bashrc file (will delete all previous alias)"
echo "[Info] 2. Add alias to .bashrc file"
echo "[Info] 3. Clean .bashrc file"
echo "[Info] 4. Exit"

read -p "[Info] Please enter your choice: " choice

echo ""

if [ $choice -eq 1 ]; then
    cleanFile
    addAliasesToFile
elif [ $choice -eq 2 ]; then
    addAliasesToFile
elif [ $choice -eq 3 ]; then
    cleanFile
else
    echo "[Info] Exiting"
fi

. /home/$USER/.bashrc
source /home/$USER/.bashrc

echo ""
echo "[IMPORTANT] Please note that source could not work in this script, you will need to run it manually"
echo "[IMPORTANT] Use this command : source /home/$USER/.bashrc"

exit
