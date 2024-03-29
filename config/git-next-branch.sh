# Get a list of all branches
all_branches=$(git branch | sed 's/.*\///' | sed 's/remotes\///' | sed 's/^[ *]*//' | sort -u)
if [ -z "$all_branches" ]; then
	echo "No branches found."
	return 1
fi

# Get the current branch
current_branch=$(git symbolic-ref --short HEAD)

# Find the next branch
next_branch=$(echo "$all_branches" | awk -v curr="$current_branch" 'BEGIN{found=0} {if(found){print; exit} if($0==curr){found=1}}')

# If next_branch is empty, take the first branch from the list
if [ -z "$next_branch" ]; then
	next_branch=$(echo "$all_branches" | head -n 1)
fi

# Switch to the next branch
git checkout "$next_branch"
