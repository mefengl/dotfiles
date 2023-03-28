#!/bin/bash

# Define color codes for echoing messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get the width of the terminal
width=$(tput cols)

# Calculate the width of the divider
divider=$(printf "%-${width}s" "-" | tr ' ' '-')

# Install pnpm using npm
echo -e "${GREEN}Installing pnpm using npm...${NC}"
npm -g install pnpm
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully installed pnpm using npm.${NC}"
else
  echo -e "${RED}Failed to install pnpm using npm.${NC}"
  exit 1
fi
echo $divider

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

# Check if the -u flag is present, uninstall packages if necessary
if [ "$1" == "-u" ]; then
  for package in "${packages[@]}"; do
    echo -e "${GREEN}Uninstalling ${package} with pnpm...${NC}"
    pnpm uninstall -g ${package}
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully uninstalled ${package} with pnpm.${NC}"
    else
      echo -e "${RED}Failed to uninstall ${package} with pnpm.${NC}"
    fi
    echo $divider
  done
else
  # Install packages and display a message
  for package in "${packages[@]}"; do
    echo -e "${GREEN}Installing ${package} with pnpm...${NC}"
    pnpm install -g ${package}
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully installed ${package} with pnpm.${NC}"
    else
      echo -e "${RED}Failed to install ${package} with pnpm.${NC}"
    fi
    echo $divider
  done
fi
