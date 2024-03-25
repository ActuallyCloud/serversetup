#!/bin/bash
prompt(){ read -p "$1 " a; return $(test $a = "y"); }

echo
echo "-----"
echo "Welcome to the updater script for Wellness, by Aura."
echo "This script will completely remove the Wellness folder, then redownload and redeploy the latest version of the website from the repository."

prompt "Do you still wish to run the script?" && {
    echo "-----"
    echo "Shutting down old Wellness..."
    echo ""

    pm2 stop wv2
    pm2 delete wv2

    echo "-----"
    echo "Removing old ACLD-Next..."
    echo ""

    rm -rf /ACLD-Next

    echo "-----"
    echo "Cloning current ACLD-Next..."
    echo ""

    gh repo clone ActuallyCloud/wellness2
    cd wellness2

    echo "-----"
    echo "Installing dependencies and building..."
    echo ""

    npm install

    echo "-----"
    echo "Starting new ACLD-Next..."
    echo ""

    pm2 start wv2.js
    pm2 save
}