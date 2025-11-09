#!/bin/bash

# Check if at least one argument is provided (environment name)
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <new-env-name> [python-version-number]"
    exit 1
fi

env_name="$1"
python_version="${2:-}"  # Default to empty if not provided

# Ensure Conda is available
if ! command -v conda &> /dev/null; then
    echo "Error: Conda is not installed or not in the PATH."
    exit 1
fi

# Create the new Conda environment
conda create -n "$env_name" python="$python_version" -y

# Initialize Conda in the script to allow activation
eval "$(conda shell.bash hook)"

# Activate the new environment
conda activate "$env_name"

# Install the required packages
conda install conda-forge::ipykernel -y
conda install conda-forge::ipywidgets -y

echo "Environment '$env_name' created with Python $python_version"