#!/bin/bash

# Define the packages to install
packages=(
    # try
    "bumpp"
    "jsinspect"

    # "npm-copilot"
    "wrangler"
    "github-pewpew"
    "serverless"
    # "opencommit"
    # "jsdoc"

    "@antfu/ni"
    "yarn"
    "kill-port"
    # vercel
    "vercel"
    "turbo"
    # vscode
    "yo"
    "generator-code"
    "vsce"
    # github
    "@githubnext/github-copilot-cli"
    # cli enhance
    "get-urls-cli"
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

if [ "${version_parts[0]}" -lt 16 ] || { [ "${version_parts[0]}" -eq 16 ] && [ "${version_parts[1]}" -lt 4 ]; }; then
    echo -e "${RED}Node.js version is below 16.4. Installing packages using npm instead of pnpm.${NC}"
    installer="npm"
else

  # Check if pnpm is already installed
  if npm list -g | grep -q "pnpm"; then
      echo -e "${GREEN}pnpm is already installed.${NC}"
      installer="pnpm"
      # npm -g install pnpm@8.5.1
      npm -g install pnpm
  else
      # Install pnpm using npm
      echo -e "${GREEN}Installing pnpm using npm...${NC}"
      # npm -g install pnpm@8.5.1
      if npm -g install pnpm; then
        echo -e "${GREEN}Successfully installed pnpm using npm.${NC}"
        installer="pnpm"
      else
        echo -e "${RED}Failed to install pnpm using npm. Falling back to npm for package installation.${NC}"
        installer="npm"
      fi
  fi
fi

echo "$divider"

# Check if the -f flag is present, force installation of all packages
force=false
if [ "$1" == "-f" ]; then
    echo -e "${GREEN}Forcing installation of all packages.${NC}"
    force=true
fi

# Install or uninstall packages based on the force flag and whether the package is installed
for package in "${packages[@]}"; do
    if $force || ! $installer list -g | grep -q "$package"; then
        if $force; then
            echo -e "${GREEN}Force installing ${package} with $installer...${NC}"
        else
            echo -e "${GREEN}Installing ${package} with $installer...${NC}"
        fi
        if $installer install -g "$package"; then
            echo -e "${GREEN}Successfully installed ${package} with $installer.${NC}"
        else
            echo -e "${RED}Failed to install ${package} with $installer.${NC}"
        fi
    else
        echo -e "${GREEN}${package} is already installed.${NC}"
    fi
    echo "$divider"
done
