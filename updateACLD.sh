#!/bin/bash
prompt(){ read -p "$1 " a; return $(test $a = "y"); }

echo
echo "-----"
echo "Welcome to the updater script for the ACLD website, by Aura."
echo "This script will completely remove the ACLD-Next folder, then redownload and redeploy the latest version of the website from the repository."

prompt "Do you still wish to run the script?" && {
    echo "-----"
    echo "Shutting down old ACLD-Next..."
    echo ""

    pm2 stop ACLD
    pm2 delete ACLD

    echo "-----"
    echo "Removing old ACLD-Next..."
    echo ""

    rm -rf /ACLD-Next

    echo "-----"
    echo "Cloning current ACLD-Next..."
    echo ""

    gh repo clone ActuallyCloud/ACLD-Next
    cd ACLD-Next

    echo "-----"
    echo "Installing dependencies and building..."
    echo ""

    npm install
    npm run build

    echo "-----"
    echo "Starting new ACLD-Next..."
    echo ""

    pm2 start npm --name "ACLD" -- start
    pm2 save
}