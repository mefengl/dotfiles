#!/bin/bash

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

# Install pnpm first
echo -e "${GREEN}Installing pnpm...${NC}"
npm install -g pnpm
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully installed pnpm.${NC}"
else
  echo -e "${RED}Failed to install pnpm.${NC}"
  exit 1
fi
echo $divider

# Install each package with pnpm and display a message
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
