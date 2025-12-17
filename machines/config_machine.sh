#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get a stable hostname / FQDN (try multiple methods)
get_fqdn() {
  local fqdn=""
  fqdn="$(hostname -f 2>/dev/null || true)"
  if [[ -z "$fqdn" || "$fqdn" == "(none)" ]]; then
    fqdn="$(hostname --fqdn 2>/dev/null || true)"
  fi
  if [[ -z "$fqdn" || "$fqdn" == "(none)" ]]; then
    fqdn="$(hostname 2>/dev/null || true)"
  fi
  echo "$fqdn"
}

FQDN="$(get_fqdn)"

# Default (optional)
CRONJOB_MACHINE="unknown"

# Match by regex (Bash regex uses [[ str =~ regex ]])
case "$FQDN" in
  # Examples — adjust to your real hostnames/domains
  (*.frontier.olcf.ornl.gov)
    CRONJOB_MACHINE="frontier"
    ;;
  (*.polaris.alcf.anl.gov)
    CRONJOB_MACHINE="polaris"
    ;;
  (*.perlmutter.nersc.gov)
    CRONJOB_MACHINE="perlmutter"
    ;;
  (*.lcrc.anl.gov)
    CRONJOB_MACHINE="chrysalis"
    ;;
  (*)
    # If you prefer to hard-fail on unknown machines:
    # echo "ERROR: Unknown machine for FQDN='$FQDN'" >&2
    # exit 1
    CRONJOB_MACHINE="unknown"
    ;;
esac

export CRONJOB_MACHINE
echo "FQDN=$FQDN"
echo "CRONJOB_MACHINE=$CRONJOB_MACHINE"

source ${SCRIPT_DIR}/config_${CRONJOB_MACHINE}.sh
