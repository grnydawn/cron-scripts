#!/usr/bin/env bash
set -eo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

echo "[$(date)] Starting $SCRIPT_NAME"

# set CRONJOB_BASEDIR and machine-specific variables
source ${HERE}/machines/config_machine.sh

export CRONJOB_LOGDIR=${CRONJOB_BASEDIR}/logs
mkdir -p $CRONJOB_LOGDIR

export CRONJOB_DATE=$(date +"%d")
export CRONJOB_TIME=$(date +"%T")

LOCKFILE="${HERE}/cronjob.lock"
exec 9>"$LOCKFILE"
if ! flock -n 9; then
    echo "[$(date)] launch_all.sh is already running, exiting."
    exit 0
fi

# Run all launch*.sh scripts under immediate subdirectories of $HERE/tasks
while IFS= read -r script; do
    /bin/bash "$script"
done < <(
    find "$HERE/tasks" -mindepth 2 -maxdepth 2 \
        -type f -name 'launch*.sh' | sort
)

echo "[$(date)] Finished $SCRIPT_NAME"
