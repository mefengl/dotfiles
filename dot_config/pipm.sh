#!/bin/bash

# Define the packages to install
packages=(
    "asitop"
    "twspace-dl"
)

# Define color codes for echoing messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get the width of the terminal
width=$(tput cols)

# Calculate the width of the divider
divider=$(printf "%-${width}s" "-" | tr ' ' '-')

# Check if Python is installed
if ! command -v python &>/dev/null; then
    echo -e "${RED}Python is not installed. Please install Python before running this script.${NC}"
    exit 1
fi

echo "$divider"

# Check if pip is installed
pip_version=$(pip --version)
if [[ -z "$pip_version" ]]; then
    echo -e "${RED}pip is not installed. Please install pip before running this script.${NC}"
    exit 1
fi

# Upgrade pip
echo -e "${GREEN}Upgrading pip...${NC}"
if ! pip install --upgrade pip; then
    echo -e "${RED}Failed to upgrade pip.${NC}"
    exit 1
fi
echo "$divider"

# Install each package
for package in "${packages[@]}"; do
    echo -e "${GREEN}Installing ${package} with pip...${NC}"
    if pip install "${package}"; then
        echo -e "${GREEN}Successfully installed ${package} with pip.${NC}"
    else
        echo -e "${RED}Failed to install ${package} with pip.${NC}"
    fi
    echo "$divider"
done
