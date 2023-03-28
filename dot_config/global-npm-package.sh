#!/bin/bash

# Define the packages to install
packages=(
  "pnpm"
  "yarn"
  "vercel"
  "turbo"
  "yo generator-code"
)

# Define color codes for echoing messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Install each package and display a message
for package in "${packages[@]}"; do
  echo -e "${GREEN}Installing ${package}...${NC}"
  npm install -g ${package}
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully installed ${package}.${NC}"
  else
    echo -e "${RED}Failed to install ${package}.${NC}"
  fi
done
