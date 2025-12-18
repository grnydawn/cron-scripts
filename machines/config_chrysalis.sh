#!/usr/bin/env bash
set -eo pipefail

export CRONJOB_BASEDIR=/lcrc/globalscratch/ac.kimy/cronjobs
export CRONJOB_COMPILERS="gnu intel"

mkdir -p "$CRONJOB_BASEDIR"
