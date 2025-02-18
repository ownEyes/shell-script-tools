#!/bin/bash

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project-folder-path> <new-repo-name>"
    exit 1
fi

# Convert relative path to absolute path
project_folder=$(realpath "$1")
new_repo_name="$2"

# Verify if the provided path is a valid Git repository
if [ ! -d "$project_folder/.git" ]; then
    echo "Error: '$project_folder' is not a valid Git repository."
    exit 1
fi

# Move into the project directory
cd "$project_folder" || exit

# Get the current SSH remote URL
old_remote_url=$(git remote get-url origin)

# Extract the GitHub username from the old URL
if [[ "$old_remote_url" =~ git@github.com:(.*)/(.*).git ]]; then
    github_user="${BASH_REMATCH[1]}"
else
    echo "Error: Unable to extract GitHub username from remote URL."
    exit 1
fi

# Construct the new SSH remote URL
new_remote_url="git@github.com:$github_user/$new_repo_name.git"

# Update the remote URL
git remote set-url origin "$new_remote_url"

# Verify the update
echo "Updated remote URL to:"
git remote -v

# Get the parent directory and rename the project folder
parent_dir=$(dirname "$project_folder")
new_project_path="$parent_dir/$new_repo_name"

# Change to the parent directory
cd "$parent_dir" || exit 1

# Rename the project folder
mv "$(basename "$project_folder")" "$new_repo_name"

echo "Project folder renamed to: $new_project_path"
