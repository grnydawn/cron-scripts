#!/bin/bash

# Configuration
export POLARIS_ROOT="/lustre/orion/cli115/scratch/grnydawn/polaris_cronjob"
REMOTE_URL="https://github.com/grnydawn/polaris.git"
BRANCH="ykim/cron-scripts"

# 1. & 2. Check existence and handle repository state
if [ ! -d "$POLARIS_ROOT/.git" ]; then
    echo "Repository not found. Cloning..."
    git clone -b "$BRANCH" "$REMOTE_URL" "$POLARIS_ROOT"
    cd "$POLARIS_ROOT" || exit
else
    echo "Repository exists. Updating to latest remote state..."
    cd "$POLARIS_ROOT" || exit
    
    # Ensure we are on the correct branch and sync with origin
    git fetch origin
    git checkout "$BRANCH"
    git reset --hard "origin/$BRANCH"
fi

# 3. Update specific submodules recursively
echo "Updating submodules..."
git submodule update --init --recursive jigsaw-python
git submodule update --init e3sm_submodules/Omega
pushd e3sm_submodules/Omega
git submodule update --init --recursive externals/ekat externals/scorpio cime components/omega/external
popd

# 4. Launch the final script with all passed arguments
LAUNCH_SCRIPT="$POLARIS_ROOT/cron-scripts/launch_all.sh"

if [ -f "$LAUNCH_SCRIPT" ]; then
    echo "Launching: $LAUNCH_SCRIPT $*"
    bash "$LAUNCH_SCRIPT" "$@"
else
    echo "Error: Launch script not found at $LAUNCH_SCRIPT"
    exit 1
fi
