#!/bin/bash
prompt(){ read -p "$1 " a; return $(test $a = "y"); }

echo
echo "-----"
echo "Welcome to first-time setup, by Aura!"
echo "Loosely based on https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)"
echo "Note: Minimal user intervention may be required. Don't walk away!"
echo
echo "Warning: This script may be destructive if you run it in anything other than a new development environment."

prompt "Do you still wish to run the script?" && {
	echo
	echo "-----"
	echo "Updating server registries..."
	
	echo
	apt update

	echo
	echo "Upgrading server packages..."
	
	echo
	apt upgrade -y

	echo
	echo "Cleaning up... (optional)"
	
	echo
	apt autoremove

	echo
	echo "-----"
	echo "Installing diagnostic tools and necessary packages..."
	
	echo
	apt install speedtest-cli -y
	echo
	apt install ufw -y
	echo
	apt install git -y
	echo
	apt install net-tools -y
	echo
	apt install iptables-persistent -y
	echo
	apt install snapd -y
	echo
	apt install unattended-upgrades -y
	echo
	apt install curl -y

	echo
	prompt "Do you want to install the latest LTS build of NodeJS?" && {
		echo
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
		source ~/.bashrc
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
		nvm install --lts
		echo
		echo "Installed Node version:"
		node -v
	}

	echo	
	prompt "Do you want to install a Java build?" && {
		echo
		prompt "Do you want to install JDK 8?" && apt install openjdk-8-jdk -y
		echo
		prompt "Do you want to install JDK 17?" && apt install openjdk-17-jdk -y 
	}

	echo
	prompt "Do you want to install Docker?" && {
		echo
		
		apt install ca-certificates curl gnupg
		install -m 0755 -d /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		chmod a+r /etc/apt/keyrings/docker.gpg

		apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
		echo 
		echo "Testing the Docker installation using Hello World..."
		echo

		docker run hello-world
	}

	echo
	echo "-----"
	echo "Removing existing firewall rules in iptables and firewalld. You may see error messages..."
	
	echo
	iptables --flush
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables-save
	
	echo
	rm -rf /etc/firewalld/zones
	systemctl restart firewalld
	
	echo
	ufw --force reset

	echo
	echo "Setting up firewall..."
	
	echo
	ufw disable
	ufw allow OpenSSH

	echo
	prompt "Do you wish to configure the firewall for web traffic?" && {
		ufw allow 80/tcp
		ufw allow 443/tcp
		ufw allow 8080/tcp
	}

	echo
	prompt "Do you wish to configure the firewall for Minecraft traffic?" && ufw allow 25565/tcp

	echo
	prompt "Do you wish to configure the firewall for Plex traffic?" && ufw allow 32400/tcp

	echo
	prompt "Do you wish to configure the firewall for Wireguard traffic?" && ufw allow 51820/udp

	echo
	echo "Enabling firewall. SSH connections will not be disconnected. Answer y to confirm."
	
	echo
	ufw enable

	echo
	echo "Check firewall status below."
	
	echo
	ufw status

	echo 
	echo "------"
	echo "Server setup has finished. Rebooting..."

	sleep 3
	reboot
}
