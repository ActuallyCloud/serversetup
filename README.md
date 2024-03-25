# Server Setup Script
This script is a simple script that sets up a cloud deployment server with standard debug/testing tools, in particular Docker, Java, and Node.js. To use, simply run the following commands after deploying a new server:
```
sudo apt update && apt install curl
curl -sSL https://raw.githubusercontent.com/ActuallyCloud/serversetup/main/automanage.sh -o automanage.sh && sudo bash ./automanage.sh
```
