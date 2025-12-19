#!/usr/bin/env bash
set -eo pipefail

source /etc/bash.bashrc

export CRONJOB_BASEDIR=/lustre/orion/cli115/scratch/grnydawn/cronjobs
export E3SM_COMPILERS="craygnu-mphipcc craycray-mphipcc crayamd-mphipcc craygnu craycray crayamd"

mkdir -p "$CRONJOB_BASEDIR"
