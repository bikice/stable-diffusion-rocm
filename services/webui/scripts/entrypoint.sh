#!/bin/bash

set -Eeuo pipefail

declare -A MOUNTS

# MOUNT["target_path"]="source_path"
MOUNTS["${ROOT}/outputs"]="/data/outputs"
MOUNTS["${ROOT}/inputs"]="/data/inputs"
MOUNTS["${ROOT}/models/Stable-diffusion"]="/data/models/Stable-diffusion"
MOUNTS["${ROOT}/models/dreambooth"]="/data/models/dreambooth"
MOUNTS["${ROOT}/models/hypernetworks"]="/data/models/hypernetworks"
MOUNTS["${ROOT}/models/VAE"]="/data/models/VAE"
#MOUNTS["${ROOT}/models/VAE-approx"]="/data/models/VAE-approx"
MOUNTS["${ROOT}/models/deepbooru"]="/data/models/deepbooru"
MOUNTS["${ROOT}/scripts"]="/data/scripts"

for target_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  source_path="${MOUNTS[${target_path}]}"

  if [ -d "${source_path}" ]; then
    if [ -d "${target_path}" ]; then
      rm -rf "${target_path}"
    else
      mkdir -vp "$(dirname "${target_path}")"
    fi
  else
    if [ -d "${target_path}" ]; then
      mv "${target_path}" "${source_path}"
    else
      mkdir -vp "${source_path}"
    fi
  fi

  if [ -f "$(dirname "${source_path}")" ]; then
    rm -rf "${source_path}"
  fi

  ln -sT "${source_path}" "${target_path}"
  echo Mounted $(basename "${source_path}")
done

exec "$@"