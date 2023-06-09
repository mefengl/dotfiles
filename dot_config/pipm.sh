#!/bin/bash

# Define the packages to install
packages=(
	"asitop"
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

echo $divider

# Check if pip is installed
pip_version=$(pip --version)
if [[ -z "$pip_version" ]]; then
	echo -e "${RED}pip is not installed. Please install pip before running this script.${NC}"
	exit 1
fi

# Check if the -f flag is present, force installation of all packages
force=false
if [ "$1" == "-f" ]; then
	echo -e "${GREEN}Forcing installation of all packages.${NC}"
	force=true
fi

# Install or uninstall packages based on the force flag and whether the package is installed
for package in "${packages[@]}"; do
	if $force || ! pip list | grep -q $package; then
		if $force; then
			echo -e "${GREEN}Force installing ${package} with pip...${NC}"
		else
			echo -e "${GREEN}Installing ${package} with pip...${NC}"
		fi
		pip install ${package}
		if [ $? -eq 0 ]; then
			echo -e "${GREEN}Successfully installed ${package} with pip.${NC}"
		else
			echo -e "${RED}Failed to install ${package} with pip.${NC}"
		fi
	else
		echo -e "${GREEN}${package} is already installed.${NC}"
	fi
	echo $divider
done
