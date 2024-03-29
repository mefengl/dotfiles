#!/bin/bash

if [ -z "$1" ]; then
	read -r -p "Enter GitHub username: " username
else
	username=$1
fi

mkdir -p ~/projects
cd ~/projects || exit

max_jobs=5
counter=0
pids=()
max_retries=3

repos=$(gh repo list "$username" --limit 100 | awk '{print $1}')

for repo in $repos; do
	retry_count=0
	while [ $retry_count -lt $max_retries ]; do
		gh repo clone "$repo" &
		pid=$!
		wait $pid
		exit_status=$?

		if [ $exit_status -eq 0 ]; then
			break
		else
			((retry_count++))
			echo "Failed to clone $repo. Retrying ($retry_count/$max_retries)..."
		fi
	done &

	pids+=($!)
	((counter++))

	if [ $counter -eq $max_jobs ]; then
		wait "${pids[0]}"
		pids=("${pids[@]:1}")
		((counter--))
	fi
done

wait
