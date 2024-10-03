#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update package list and install required packages
echo "Updating package list..."
apt update

echo "Installing Python3, Pip3, and Git..."
apt install -y python3 python3-pip git

# Clone the Flask application repository
REPO_URL="https://github.com/uwidcit/flaskmvc.git"
APP_DIR="flaskmvc"  # Directory name for the cloned repository

if [ ! -d "$APP_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL"
else
    echo "Directory $APP_DIR already exists. Pulling latest changes..."
    cd "$APP_DIR"
    git pull
    cd ..
fi

# Change to the application directory
cd "$APP_DIR" || exit

# Install the required Python packages from requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip3 install -r requirements.txt
else
    echo "requirements.txt not found!"
    exit 1
fi

# Start the Flask server in production mode
# Assuming the main entry point is app.py (update if different)
FLASK_APP=app.py FLASK_ENV=production flask run --host=0.0.0.0 --port=5000 &

echo "Flask application is running in production mode at http://localhost:5000"
chmod +x setup.sh
sudo ./setup.sh

