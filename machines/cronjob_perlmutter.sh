#!/bin/bash

# Configuration
REPO_PATH="/global/cfs/cdirs/e3sm/youngsun/repos/github/polaris_cronjob"
REMOTE_URL="git@github.com:grnydawn/polaris.git"
BRANCH="ykim/cron-scripts"

# 1. & 2. Check existence and handle repository state
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Repository not found. Cloning..."
    git clone -b "$BRANCH" "$REMOTE_URL" "$REPO_PATH"
    cd "$REPO_PATH" || exit
else
    echo "Repository exists. Updating to latest remote state..."
    cd "$REPO_PATH" || exit
    
    # Ensure we are on the correct branch and sync with origin
    git fetch origin
    git checkout "$BRANCH"
    git reset --hard "origin/$BRANCH"
fi

# 3. Update specific submodules recursively
echo "Updating submodules..."
git submodule update --init --recursive jigsaw-python
pushd e3sm_submodules/Omega
git submodule update --init --recursive externals/ekat externals/scorpio cime components/omega/external
popd

# 4. Launch the final script with all passed arguments
LAUNCH_SCRIPT="$REPO_PATH/cron-scripts/launch_all.sh"

if [ -f "$LAUNCH_SCRIPT" ]; then
    echo "Launching: $LAUNCH_SCRIPT $*"
    bash "$LAUNCH_SCRIPT" "$@"
else
    echo "Error: Launch script not found at $LAUNCH_SCRIPT"
    exit 1
fi
