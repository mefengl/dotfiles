#!/bin/bash

read -p "Enter GitHub username: " username

mkdir -p ~/projects/$username; cd ~/projects/$username;
gh repo list $username | awk '{print $1}' | xargs -L1 gh repo clone
# find . -type d -name ".git" | xargs -P10 -L1 dirname | xargs -L1 -I {} sh -c "cd {}; gptcommit install"

