#!/bin/bash

# not compatible with pnpm
npm -g install ni

# Define the packages to install
packages=(
"yarn"
# vercel
"vercel"
"turbo"
# vscode
"yo generator-code"
# github
"@githubnext/github-copilot-cli"
)

# Define color codes for echoing messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get the width of the terminal
width=$(tput cols)

# Calculate the width of the divider
divider=$(printf "%-${width}s" "-" | tr ' ' '-')

# Check Node.js version
node_version=$(node -v | cut -c2-)
IFS='.' read -ra version_parts <<< "$node_version"

if [ ${version_parts[0]} -lt 16 ] || ([ ${version_parts[0]} -eq 16 ] && [ ${version_parts[1]} -lt 4 ]); then
  echo -e "${RED}Node.js version is below 16.4. Installing packages using npm instead of pnpm.${NC}"
  installer="npm"
else
  # Install pnpm using npm
  echo -e "${GREEN}Installing pnpm using npm...${NC}"
  npm -g install pnpm
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully installed pnpm using npm.${NC}"
    installer="pnpm"
  else
    echo -e "${RED}Failed to install pnpm using npm. Falling back to npm for package installation.${NC}"
    installer="npm"
  fi
fi

echo $divider

# Check if the -u flag is present, uninstall packages if necessary
if [ "$1" == "-u" ]; then
  for package in "${packages[@]}"; do
    echo -e "${GREEN}Uninstalling ${package} with $installer...${NC}"
    $installer uninstall -g ${package}
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully uninstalled ${package} with $installer.${NC}"
    else
      echo -e "${RED}Failed to uninstall ${package} with $installer.${NC}"
    fi
    echo $divider
  done
else
  # Install packages and display a message
  for package in "${packages[@]}"; do
    echo -e "${GREEN}Installing ${package} with $installer...${NC}"
    $installer install -g ${package}
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully installed ${package} with $installer.${NC}"
    else
      echo -e "${RED}Failed to install ${package} with $installer.${NC}"
    fi
    echo $divider
  done
fi
