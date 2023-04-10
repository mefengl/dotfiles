#!/bin/bash

read -p "Enter GitHub username: " username

mkdir -p ~/projects/$username
cd ~/projects/$username

max_jobs=5
counter=0
pids=()
max_retries=3

gh repo list $username | awk '{print $1}' | while read repo; do
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