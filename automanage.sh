#!/bin/bash
prompt(){ read -p "$1 " a; return $(test $a = "y"); }

echo
echo "-----"
echo "Welcome to first-time setup, by Aura!"
echo "Loosely based on https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)"
echo "Note: Minimal user intervention may be required. Don't walk away!"
echo
echo "Warning: This script may be destructive if you run it in anything other than a new development environment."

prompt "Do you still wish to run the script? (y to confirm)" && {
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
	sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
	echo
	apt install speedtest-cli git net-tools snapd unattended-upgrades zip unzip -y
	echo

	prompt "Do you want to attempt to install firewall management tools? (You can choose individually for each tool)" && {
		echo
		prompt "Do you want to install iptables? (Not recommended)" && apt install iptables iptables-persistent -y
		echo
		prompt "Do you want to install ufw?" && apt install ufw -y
		echo
		prompt "Do you want to install firewalld?" && apt install firewalld -y
	}

	echo
	prompt "Do you want to install the latest LTS build of NodeJS? (y to confirm)" && {
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
	prompt "Do you want to install a Java build? (y to confirm)" && {
		echo
		prompt "Do you want to install JDK 8?" && apt install openjdk-8-jdk -y
		echo
		prompt "Do you want to install JDK 17?" && apt install openjdk-17-jdk -y 
		echo
		prompt "Do you want to install JDK 18?" && apt install openjdk-18-jdk -y 
		echo
		prompt "Do you want to install JDK 19?" && apt install openjdk-19-jdk -y 
	}

	echo
	prompt "Do you want to install Docker? (y to confirm)" && {
		echo
		
		apt install ca-certificates
		install -m 0755 -d /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
		sudo chmod a+r /etc/apt/keyrings/docker.asc
		echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		apt update

		apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
		echo 
		echo "Testing the Docker installation using Hello World..."
		echo

		docker run hello-world
	}

	echo "------"
	echo "Server setup has finished. Rebooting in 5..."

	sleep 5
	reboot
}
